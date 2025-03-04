$ErrorActionPreference = 'Stop'

if ($PSVersionTable.PSVersion.Major -eq 2) {
    $PSScriptRoot = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
}

if (-not (Get-Command -Name Get-ScheduledTask -ErrorAction SilentlyContinue) -or
    -not (Get-Command -Name Disable-ScheduledTask -ErrorAction SilentlyContinue)) {
    Import-Module -Name "$PSScriptRoot\Modules\ScheduledTasks.psm1" -Force
}

if ([System.Environment]::OSVersion.Version.Major -eq 6) {
    Write-Host 'Windows Media Player : Prevent Windows Media DRM Internet Access : Enabled'
    $Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WMDRM\'
    (Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
    New-ItemProperty -Path $Key -Name DisableOnline -Value 1 -PropertyType DWord -Force | Out-Null

    # --------------------------------------------------------------------------

    $Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsMediaPlayer\'
    (Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null

    Write-Host 'Windows Media Player : Prevent Desktop Shortcut Creation : Enabled'
    New-ItemProperty -Path $Key -Name DesktopShortcut -Value no -PropertyType String -Force | Out-Null

    Write-Host 'Windows Media Player : Prevent Quick Launch Toolbar Shortcut Creation : Enabled'
    New-ItemProperty -Path $Key -Name QuickLaunchShortcut -Value no -PropertyType String -Force | Out-Null

    Write-Host 'Windows Media Player : Prevent Automatic Updates : Enabled'
    New-ItemProperty -Path $Key -Name DisableAutoUpdate -Value 1 -PropertyType DWord -Force | Out-Null

    Write-Host 'Windows Media Player : Do Not Show First Use Dialog Boxes : Enabled'
    New-ItemProperty -Path $Key -Name GroupPrivacyAcceptance -Value 1 -PropertyType DWord -Force | Out-Null

    Write-Host 'Windows Media Player : Prevent Media Sharing : Enabled'
    New-ItemProperty -Path $Key -Name PreventLibrarySharing -Value 1 -PropertyType DWord -Force | Out-Null

    Write-Host 'Windows Media Center : Disabled'
    New-ItemProperty -Path $Key -Name MediaCenter -Value 1 -PropertyType DWord -Force | Out-Null

    # --------------------------------------------------------------------------

    $Key = 'HKCU:\Software\Policies\Microsoft\WindowsMediaCenter\'
    (Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
    New-ItemProperty -Path $Key -Name MediaCenter -Value 1 -PropertyType DWord -Force | Out-Null

    # --------------------------------------------------------------------------

    Write-Host 'Service : Windows Media Center Receiver Service : Disabled'
    Stop-Service -Name ehRecvr -Force -ErrorAction SilentlyContinue
    Set-Service -Name ehRecvr -Status Stopped -StartupType Disabled -ErrorAction SilentlyContinue

    Write-Host 'Service : Windows Media Center Scheduler Service : Disabled'
    Stop-Service -Name ehSched -Force -ErrorAction SilentlyContinue
    Set-Service -Name ehSched -Status Stopped -StartupType Disabled -ErrorAction SilentlyContinue

    Write-Host 'Service : Media Center Extender Service : Disabled'
    Stop-Service -Name Mcx2Svc -Force -ErrorAction SilentlyContinue
    Set-Service -Name Mcx2Svc -Status Stopped -StartupType Disabled -ErrorAction SilentlyContinue

    Write-Host 'Scheduled Tasks : \Microsoft\Windows\Media Center\* : Disabled'
    Get-ScheduledTask -TaskPath '\Microsoft\Windows\Media Center\' | Disable-ScheduledTask
}

# ------------------------------------------------------------------------------

Write-Host 'Service : Windows Media Player Network Sharing Service : Disabled'
Stop-Service -Name WMPNetworkSvc -Force -ErrorAction SilentlyContinue
Set-Service -Name WMPNetworkSvc -Status Stopped -StartupType Disabled -ErrorAction SilentlyContinue

Write-Host 'Scheduled Tasks : \Microsoft\Windows\Windows Media Sharing\* : Disabled'
Get-ScheduledTask -TaskPath '\Microsoft\Windows\Windows Media Sharing\' | Disable-ScheduledTask
