$ErrorActionPreference = "Stop"

$Key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)

Write-Host "Explorer : Do not keep history of recently opened documents : Enabled"
$null = New-ItemProperty -Path $Key -Name NoRecentDocsHistory -Value 1 -PropertyType DWord -Force

Write-Host "Explorer : Clear history of recently opened documents on exit : Enabled"
$null = New-ItemProperty -Path $Key -Name ClearRecentDocsOnExit -Value 1 -PropertyType DWord -Force

Write-Host "Explorer : Clear the recent programs list for new users : Enabled"
$null = New-ItemProperty -Path $Key -Name ClearRecentProgForNewUserInStartMenu -Value 1 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "Explorer : Show drive letters : Enabled"
$Key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\"
$null = New-ItemProperty -Path $Key -Name ShowDriveLettersFirst -Value 1 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

$Key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\"

Write-Host "Explorer : Show pop-up description for folder and desktop items : Enabled"
$null = New-ItemProperty -Path $Key -Name ShowInfoTip -Value 1 -PropertyType DWord -Force

Write-Host "Explorer : Show hidden files, folders and drives : Enabled"
$null = New-ItemProperty -Path $Key -Name Hidden -Value 1 -PropertyType DWord -Force

Write-Host "Explorer : Hide extensions for known file types : Disabled"
$null = New-ItemProperty -Path $Key -Name HideFileExt -Value 0 -PropertyType DWord -Force

Write-Host "Explorer : Hide empty drives in the Computer folder : Enabled"
$null = New-ItemProperty -Path $Key -Name HideDrivesWithNoMedia -Value 1 -PropertyType DWord -Force

Write-Host "Explorer : Always show icons, never thumbnails : Disabled"
$null = New-ItemProperty -Path $Key -Name IconsOnly -Value 0 -PropertyType DWord -Force

Write-Host "Explorer : Display file icon on thumbnails : Enabled"
$null = New-ItemProperty -Path $Key -Name ShowTypeOverlay -Value 1 -PropertyType DWord -Force

Write-Host "Explorer : Display the file size information in folder tips : Enabled"
$null = New-ItemProperty -Path $Key -Name FolderContentsInfoTip -Value 1 -PropertyType DWord -Force

Write-Host "Explorer : Hide protected operating system files : Enabled"
$null = New-ItemProperty -Path $Key -Name ShowSuperHidden -Value 0 -PropertyType DWord -Force

Write-Host "Explorer : Always show menus : Disabled"
$null = New-ItemProperty -Path $Key -Name AlwaysShowMenus -Value 0 -PropertyType DWord -Force

Write-Host "Explorer : Launch folder windows in a separate process : Disabled"
$null = New-ItemProperty -Path $Key -Name SeparateProcess -Value 0 -PropertyType DWord -Force

Write-Host "Explorer : Restore previous folder windows at logon : Disabled"
$null = New-ItemProperty -Path $Key -Name PersistBrowsers -Value 0 -PropertyType DWord -Force

Write-Host "Explorer : Use Sharing Wizard : Enabled"
$null = New-ItemProperty -Path $Key -Name SharingWizardOn -Value 1 -PropertyType DWord -Force

Write-Host "Explorer : When typing into list view, select the typed item in the view..."
$null = New-ItemProperty -Path $Key -Name TypeAhead -Value 0 -PropertyType DWord -Force

Write-Host "Explorer : Show all folders in navigation pane : Disabled"
$null = New-ItemProperty -Path $Key -Name NavPaneShowAllFolders -Value 0 -PropertyType DWord -Force

Write-Host "Explorer : Automatically expand to current folder in navigation pane : Disabled"
$null = New-ItemProperty -Path $Key -Name NavPaneExpandToCurrentFolder -Value 0 -PropertyType DWord -Force

Write-Host "Explorer : Show pretty path : Enabled"
$null = New-ItemProperty -Path $Key -Name DontPrettyPath -Value 0 -PropertyType DWord -Force

Write-Host "Explorer : Lock the taskbar : Enabled"
$null = New-ItemProperty -Path $Key -Name TaskbarSizeMove -Value 0 -PropertyType DWord -Force

Write-Host "Explorer : Use small icons in taskbar : Disabled"
$null = New-ItemProperty -Path $Key -Name TaskbarSmallIcons -Value 0 -PropertyType DWord -Force

Write-Host "Explorer : Always combine and hide program names or labels in taskbar..."
$null = New-ItemProperty -Path $Key -Name TaskbarGlomLevel -Value 0 -PropertyType DWord -Force

Write-Host "Explorer : Show desktop icons : Enabled"

$null = New-ItemProperty -Path $Key -Name HideIcons -Value 0 -PropertyType DWord -Force
#-----------------------------------------------------------------------------------------------------------------------

if ([System.Environment]::OSVersion.Version.Major -eq 6) {
    Write-Host "Explorer : Do not add shares of recently opened documents to Network Locations : Enabled"
    $Key = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\"
    $null = (Test-Path -Path $Key -PathType Container) -or (New-Item -Path $Key -Force)
    $null = New-ItemProperty -Path $Key -Name NoRecentDocsNetHood -Value 1 -PropertyType DWord -Force

    #-------------------------------------------------------------------------------------------------------------------

    Write-Host "Explorer : Use Aero Peek to preview the desktop : Disabled"
    $Key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\"
    $null = New-ItemProperty -Path $Key -Name DisablePreviewDesktop -Value 1 -PropertyType DWord -Force
}

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "Explorer : Control Panel : View by small icons..."
$Key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel\"
$null = (Test-Path -Path $Key -PathType Container) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name AllItemsIconView -Value 1 -PropertyType DWord -Force
$null = New-ItemProperty -Path $Key -Name StartupPage -Value 1 -PropertyType DWord -Force
