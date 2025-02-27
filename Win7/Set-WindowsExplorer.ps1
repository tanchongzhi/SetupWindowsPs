$ErrorActionPreference = 'Stop'

$Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null

Write-Host 'Explorer : Do not keep history of recently opened documents : Enabled'
New-ItemProperty -Path $Key -Name NoRecentDocsHistory -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Explorer : Clear history of recently opened documents on exit : Enabled'
New-ItemProperty -Path $Key -Name ClearRecentDocsOnExit -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Explorer : Clear the recent programs list for new users : Enabled'
New-ItemProperty -Path $Key -Name ClearRecentProgForNewUserInStartMenu -Value 1 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Explorer : Show drive letters : Enabled'
$Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\'
New-ItemProperty -Path $Key -Name ShowDriveLettersFirst -Value 1 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

$Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\'

Write-Host 'Explorer : Show pop-up description for folder and desktop items : Enabled'
New-ItemProperty -Path $Key -Name ShowInfoTip -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Explorer : Show hidden files, folders and drives : Enabled'
New-ItemProperty -Path $Key -Name Hidden -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Explorer : Hide extensions for known file types : Disabled'
New-ItemProperty -Path $Key -Name HideFileExt -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'Explorer : Hide empty drives in the Computer folder : Enabled'
New-ItemProperty -Path $Key -Name HideDrivesWithNoMedia -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Explorer : Always show icons, never thumbnails : Disabled'
New-ItemProperty -Path $Key -Name IconsOnly -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'Explorer : Display file icon on thumbnails : Enabled'
New-ItemProperty -Path $Key -Name ShowTypeOverlay -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Explorer : Display the file size information in folder tips : Enabled'
New-ItemProperty -Path $Key -Name FolderContentsInfoTip -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Explorer : Hide protected operating system files : Enabled'
New-ItemProperty -Path $Key -Name ShowSuperHidden -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'Explorer : Always show menus : Disabled'
New-ItemProperty -Path $Key -Name AlwaysShowMenus -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'Explorer : Launch folder windows in a separate process : Disabled'
New-ItemProperty -Path $Key -Name SeparateProcess -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'Explorer : Restore previous folder windows at logon : Disabled'
New-ItemProperty -Path $Key -Name PersistBrowsers -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'Explorer : Use Sharing Wizard : Enabled'
New-ItemProperty -Path $Key -Name SharingWizardOn -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Explorer : When typing into list view, select the typed item in the view...'
New-ItemProperty -Path $Key -Name TypeAhead -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'Explorer : Show all folders in navigation pane : Disabled'
New-ItemProperty -Path $Key -Name NavPaneShowAllFolders -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'Explorer : Automatically expand to current folder in navigation pane : Disabled'
New-ItemProperty -Path $Key -Name NavPaneExpandToCurrentFolder -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'Explorer : Show pretty path : Enabled'
New-ItemProperty -Path $Key -Name DontPrettyPath -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'Explorer : Lock the taskbar : Enabled'
New-ItemProperty -Path $Key -Name TaskbarSizeMove -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'Explorer : Use small icons in taskbar : Disabled'
New-ItemProperty -Path $Key -Name TaskbarSmallIcons -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'Explorer : Always combine and hide program names or labels in taskbar...'
New-ItemProperty -Path $Key -Name TaskbarGlomLevel -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'Explorer : Show desktop icons : Enabled'
New-ItemProperty -Path $Key -Name HideIcons -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

if ([System.Environment]::OSVersion.Version.Major -eq 6) {
    Write-Host 'Explorer : Do not add shares of recently opened documents to Network Locations : Enabled'
    $Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\'
    (Test-Path -Path $Key -PathType Container) -or (New-Item -Path $Key -Force) | Out-Null
    New-ItemProperty -Path $Key -Name NoRecentDocsNetHood -Value 1 -PropertyType DWord -Force | Out-Null

    #---------------------------------------------------------------------------

    Write-Host 'Explorer : Use Aero Peek to preview the desktop : Disabled'
    $Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\'
    New-ItemProperty -Path $Key -Name DisablePreviewDesktop -Value 1 -PropertyType DWord -Force | Out-Null
}

#-------------------------------------------------------------------------------

Write-Host 'Explorer : Control Panel : View by small icons...'
$Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel\'
(Test-Path -Path $Key -PathType Container) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name AllItemsIconView -Value 1 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name StartupPage -Value 1 -PropertyType DWord -Force | Out-Null
