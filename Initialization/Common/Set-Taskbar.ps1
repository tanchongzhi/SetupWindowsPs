$ErrorActionPreference = 'Stop'

$osVersion = [System.Environment]::OSVersion.Version

if ($osVersion.Major -ge 10) {
    $policyKeys = @(
        'HKLM:\Software\Policies\Microsoft\Windows\Windows Feeds'
    )
    $policyKeys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

    #

    Write-Host 'Taskbar Policy : Enable news and interests on the taskbar : Disabled'
    Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Feeds' -Name EnableFeeds -Value 0 -Type DWord

    #

    $settingKeys = @(
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People'
    )
    $settingKeys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

    #

    Write-Host 'Taskbar : Enable news and interests on the taskbar : Disabled'
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds' -Name ShellFeedsTaskbarViewMode -Value 2 -Type DWord -ErrorAction SilentlyContinue
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds' -Name EnShellFeedsTaskbarViewMode -Value 3080428158 -Type DWord
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds' -Name ShellFeedsTaskbarOpenOnHover -Value 0 -Type DWord

    Write-Host 'Taskbar : Replace Command Prompt with Windows PowerShell in the menu when I right click the start button or press Windows key+X : Enabled'
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name DontUsePowerShellOnWinX -Value 0 -Type DWord

    Write-Host 'Taskbar : Show badges on taskbar buttons : Enabled'
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name TaskbarBadges -Value 0 -Type DWord

    Write-Host "Taskbar : Don't show Cortana button on the taskbar : Enabled"
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name ShowCortanaButton -Value 0 -Type DWord

    Write-Host "Taskbar : Don't show People button on the taskbar : Enabled"
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People' -Name PeopleBand -Value 0 -Type DWord
}

Write-Host 'Taskbar : Lock the taskbar : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name TaskbarSizeMove -Value 0 -Type DWord

Write-Host 'Taskbar : Automatically hide the taskbar in tablet mode : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name TaskbarAutoHideInTabletMode -Value 0 -Type DWord

Write-Host 'Taskbar : Use small icons in taskbar : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name TaskbarSmallIcons -Value 0 -Type DWord

Write-Host 'Taskbar : Combine taskbar buttons when taskbar is full'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name TaskbarGlomLevel -Value 1 -Type DWord

Write-Host 'Taskbar : Use Peek to preview the desktop when you move your mouse to the Show desktop button at the end of the taskbar : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name DisablePreviewDesktop -Value 1 -Type DWord

Write-Host 'Taskbar : Always show tray icons on the taskbar : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer' -Name EnableAutoTray -Value 0 -Type DWord

if (($osVersion.Major -ge 10) -and ($osVersion.Build -ge 22000)) {
    Write-Host 'Taskbar : Alignment : Left'
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name TaskbarAl -Value 0 -Type DWord
}

#-------------------------------------------------------------------------------

$NativeMethodsDefinition = @'
[DllImport("user32.dll", CharSet = CharSet.Unicode)]
public static extern IntPtr SendMessageTimeoutW(IntPtr hWnd, uint Msg, IntPtr wParam, string lParam, uint fuFlags, uint uTimeout, IntPtr lpdwResult);
'@

if (-not ('MyInterop.Messaging' -as [type])) {
    Add-Type -Namespace MyInterop -Name Messaging -MemberDefinition $NativeMethodsDefinition
}

function Send-SystemSettingChangeMessage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $Name
    )

    $HWND_BROADCAST = [IntPtr]0xFFFF
    $WM_SETTINGCHANGE = 0x001A
    $SMTO_ABORTIFHUNG = 0x0002
    $SMTO_NOTIMEOUTIFNOTHUNG = 0x0008

    $flags = $SMTO_ABORTIFHUNG -bor $SMTO_NOTIMEOUTIFNOTHUNG
    $null = [MyInterop.Messaging]::SendMessageTimeoutW($HWND_BROADCAST, $WM_SETTINGCHANGE, [IntPtr]::Zero, $Name, $flags, 15000, [IntPtr]::Zero)
}

# StuckRects<N> Data:
#   offset 0x00, 4 bytes: Size (Windows 7/8: 40; Windows 10/11: 48)
#   offset 0x04, 4 bytes: Signature (Windows 7/8: -1 (0xffffffff); Windows 10: -2 (0xfffffffe))
#   offset 0x08, 4 bytes: Flags: TopMost ; Available: AutoHide (0x0001), TopMost (0x0002), HideClock (0x0008)
#   offset 0x0c, 4 bytes: StuckPlace: Bottom ; Available: Left (0), Top (1), Right (2), Bottom (3)
#   offset 0x10, 4 bytes: StuckWidths: cx
#   offset 0x14, 4 bytes: StuckWidths: cy
#   offset 0x18, 4 bytes: LastStuck: left
#   offset 0x1c, 4 bytes: LastStuck: top
#   offset 0x20, 4 bytes: LastStuck: right
#   offset 0x24, 4 bytes: LastStuck: bottom
#   offset 0x28, 4 bytes: Unknown, Windows 10+
#   offset 0x2c, 4 bytes: Unknown, Windows 10+
#
# Note: Modifying the Flags and position while retaining the original size data and rectangle data does not affect the actual behavior of the settings.
# Note: All explorer processes should be terminated before writing new settings, otherwise the old settings stored in explorer's memory will overwrite the new settings upon logout.
# Note: The taskbar position is locked to the bottom of the screen in Windows 11 and cannot be changed through the GUI.

$stuckRectsSettings = if ($osVersion.Major -eq 6) {
    (Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects2' -Name Settings).Settings
} else {
    (Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3' -Name Settings).Settings
}

Write-Host 'Taskbar : Automatically hide the taskbar in desktop mode : Disabled'
$stuckRectsSettings[0x08] = $stuckRectsSettings[0x08] -band -bnot 0x0001

Write-Host 'Taskbar : Taskbar location on screen : Bottom'
$stuckRectsSettings[0x0c] = 3

Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue

if ($osVersion.Major -eq 6) {
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects2\' -Name Settings -Value $stuckRectsSettings -Type Binary
} else {
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3\' -Name Settings -Value $stuckRectsSettings -Type Binary
}

if (-not (Get-Process -Name explorer -ErrorAction SilentlyContinue)) {
    explorer.exe
}

Send-SystemSettingChangeMessage -Name TraySettings
Send-SystemSettingChangeMessage -Name SaveTaskbar

#-------------------------------------------------------------------------------
