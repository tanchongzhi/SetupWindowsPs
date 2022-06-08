$ErrorActionPreference = "Stop"

Write-Host "Windows Explorer : Remove `"Recently added`" list from Start Menu : Enabled"
$Keys = @(
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer\",
    "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer\"
)
$Keys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null
$null = New-ItemProperty -Path $Keys -Name HideRecentlyAddedApps -Value 1 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

$Key = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)

Write-Host "Windows Explorer: Remove frequent programs list from the Start Menu : Enabled"
$null = New-ItemProperty -Path $Key -Name NoStartMenuMFUprogramsList -Value 1 -PropertyType DWord -Force

Write-Host "Windows Explorer: Do not keep history of recently opened documents : Enabled"
$null = New-ItemProperty -Path $Key -Name NoRecentDocsHistory -Value 1 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

$Key = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)

Write-Host "Windows Explorer: Clear tile notifications during log on : Enabled"
$null = New-ItemProperty -Path $Key -Name ClearTilesOnExit -Value 1 -PropertyType DWord -Force

Write-Host "Windows Explorer: Do not allow pinning items in Jump Lists : Enabled"
$null = New-ItemProperty -Path $Key -Name NoPinningToDestinations -Value 1 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

$Key = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)

Write-Host "Windows Explorer: Remove Recent Items menu from Start Menu : Enabled"
$null = New-ItemProperty -Path $Key -Name NoRecentDocsMenu -Value 1 -PropertyType DWord -Force

Write-Host "Windows Explorer: Do not keep history of recently opened documents : Enabled"
$null = New-ItemProperty -Path $Key -Name NoRecentDocsHistory -Value 1 -PropertyType DWord -Force

Write-Host "Windows Explorer: Turn off user tracking : Enabled"
$null = New-ItemProperty -Path $Key -Name NoInstrumentation -Value 1 -PropertyType DWord -Force

Write-Host "Windows Explorer: Clear the recent programs list for new users : Enabled"
$null = New-ItemProperty -Path $Key -Name ClearRecentProgForNewUserInStartMenu -Value 1 -PropertyType DWord -Force

Write-Host "Windows Explorer: Clear history of recently opened documents on exit : Enabled"
$null = New-ItemProperty -Path $Key -Name ClearRecentDocsOnExit -Value 1 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "Windows Explorer: Enable news and interests on the taskbar : Disabled"
$Key = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name EnableFeeds -Value 0 -PropertyType DWord -Force

$Key = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name ShellFeedsTaskbarViewMode -Value 2 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

$Key = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)

Write-Host "Windows Explorer : Show hidden files, folders and drives : Enabled"
$null = New-ItemProperty -Path $Key -Name Hidden -Value 1 -PropertyType DWord -Force

Write-Host "Windows Explorer : Hide extensions for known file types : Disabled"
$null = New-ItemProperty -Path $Key -Name HideFileExt -Value 0 -PropertyType DWord -Force

Write-Host "Windows Explorer : Lock the taskbar : Enabled"
$null = New-ItemProperty -Path $Key -Name TaskbarSizeMove -Value 0 -PropertyType DWord -Force

Write-Host "Windows Explorer : Combine and hide program names or labels when taskbar is full"
$null = New-ItemProperty -Path $Key -Name TaskbarGlomLevel -Value 1 -PropertyType DWord -Force

Write-Host "Windows Explorer : Turn off Peek at Desktop : Enabled"
$null = New-ItemProperty -Path $Key -Name DisablePreviewDesktop -Value 1 -PropertyType DWord -Force

Write-Host "Windows Explorer: Don't show Cortana button on the taskbar : Enabled"
$null = New-ItemProperty -Path $Key -Name ShowCortanaButton -Value 0 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "Windows Explorer: Always show tray icons on the taskbar : Enabled"
$Key = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name EnableAutoTray -Value 0 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "Windows Explorer: Don't show People button on the taskbar : Enabled"
$Key = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name PeopleBand -Value 0 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

$Keys = @(
    "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu\",
    "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel\"
)
$Keys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

Write-Host "Windows Explorer: Show `"This PC`" icon on the desktop : Enabled"
$null = New-ItemProperty -Path $Keys -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Value 0 -PropertyType DWord -Force

Write-Host "Windows Explorer: Show `"Recycle Bin`" icon on the desktop : Enabled"
$null = New-ItemProperty -Path $Keys -Name "{645FF040-5081-101B-9F08-00AA002F954E}" -Value 0 -PropertyType DWord -Force

Write-Host "Windows Explorer: Show `"User Documents`" icon on the desktop : Enabled"
$null = New-ItemProperty -Path $Keys -Name "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" -Value 0 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "Windows Explorer : Control Panel : View by small icons : Enabled"
$Key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name AllItemsIconView -Value 1 -PropertyType DWord -Force
$null = New-ItemProperty -Path $Key -Name StartupPage -Value 1 -PropertyType DWord -Force
