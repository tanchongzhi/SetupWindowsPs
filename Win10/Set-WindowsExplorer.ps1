$ErrorActionPreference = 'Stop'

$Keys = @(
    'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer\',
    'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer\'
)
$Keys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

Write-Host "Windows Explorer : Remove `"Recently added`" list from Start Menu : Enabled"
New-ItemProperty -Path $Keys -Name HideRecentlyAddedApps -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host "Windows Explorer : Hide `"Most used`" list from Start menu : Enabled"
New-ItemProperty -Path $Keys -Name ShowOrHideMostUsedApps -Value 2 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

$Key = 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null

Write-Host 'Windows Explorer Policies : Clear tile notifications during log on : Enabled'
New-ItemProperty -Path $Key -Name ClearTilesOnExit -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Windows Explorer Policies : Do not allow pinning items in Jump Lists : Enabled'
New-ItemProperty -Path $Key -Name NoPinningToDestinations -Value 1 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

$Keys = @(
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\',
    'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\'
)
$Keys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

Write-Host 'Windows Explorer Policies : Remove frequent programs list from the Start Menu : Enabled'
New-ItemProperty -Path $Keys -Name NoStartMenuMFUprogramsList -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Windows Explorer Policies : Do not keep history of recently opened documents : Enabled'
New-ItemProperty -Path $Keys -Name NoRecentDocsHistory -Value 1 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

$Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null

Write-Host 'Windows Explorer Policies : Remove Recent Items menu from Start Menu : Enabled'
New-ItemProperty -Path $Key -Name NoRecentDocsMenu -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Windows Explorer Policies : Turn off user tracking : Enabled'
New-ItemProperty -Path $Key -Name NoInstrumentation -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Windows Explorer Policies : Clear the recent programs list for new users : Enabled'
New-ItemProperty -Path $Key -Name ClearRecentProgForNewUserInStartMenu -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Windows Explorer Policies : Clear history of recently opened documents on exit : Enabled'
New-ItemProperty -Path $Key -Name ClearRecentDocsOnExit -Value 1 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Windows Explorer Policies : Enable news and interests on the taskbar : Disabled'
$Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name EnableFeeds -Value 0 -PropertyType DWord -Force | Out-Null

$Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name ShellFeedsTaskbarViewMode -Value 2 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path $Key -Name EnShellFeedsTaskbarViewMode -Value 3080428158 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name ShellFeedsTaskbarOpenOnHover -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

$Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null

Write-Host 'Windows Explorer : Show hidden files, folders and drives : Enabled'
New-ItemProperty -Path $Key -Name Hidden -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Windows Explorer : Hide extensions for known file types : Disabled'
New-ItemProperty -Path $Key -Name HideFileExt -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'Windows Explorer : Lock the taskbar : Enabled'
New-ItemProperty -Path $Key -Name TaskbarSizeMove -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'Windows Explorer : Combine and hide program names or labels when taskbar is full'
New-ItemProperty -Path $Key -Name TaskbarGlomLevel -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Windows Explorer : Turn off Peek at Desktop : Enabled'
New-ItemProperty -Path $Key -Name DisablePreviewDesktop -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host "Windows Explorer : Don't show Cortana button on the taskbar : Enabled"
New-ItemProperty -Path $Key -Name ShowCortanaButton -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

$Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null

Write-Host 'Windows Explorer : Display the full path in the title bar : Enabled'
New-ItemProperty -Path $Key -Name FullPath -Value 1 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

$Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null

Write-Host 'Windows Explorer : Show recently used files in Quick Access : Disabled'
New-ItemProperty -Path $Key -Name ShowRecent -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'Windows Explorer : Show frequently used folders in Quick Access : Disabled'
New-ItemProperty -Path $Key -Name ShowFrequent -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'Windows Explorer : Always show tray icons on the taskbar : Enabled'
New-ItemProperty -Path $Key -Name EnableAutoTray -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host "Windows Explorer : Don't show People button on the taskbar : Enabled"
$Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name PeopleBand -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

$Keys = @(
    'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu\',
    'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel\'
)
$Keys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

Write-Host "Windows Explorer : Show `"This PC`" icon on the desktop : Enabled"
New-ItemProperty -Path $Keys -Name '{20D04FE0-3AEA-1069-A2D8-08002B30309D}' -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host "Windows Explorer : Show `"Recycle Bin`" icon on the desktop : Enabled"
New-ItemProperty -Path $Keys -Name '{645FF040-5081-101B-9F08-00AA002F954E}' -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host "Windows Explorer : Show `"$env:USERNAME`" icon on the desktop : Enabled"
New-ItemProperty -Path $Keys -Name '{59031a47-3f72-44a7-89c5-5595fe6b30ee}' -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Windows Explorer : Control Panel : View by small icons : Enabled'
$Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name AllItemsIconView -Value 1 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name StartupPage -Value 1 -PropertyType DWord -Force | Out-Null
