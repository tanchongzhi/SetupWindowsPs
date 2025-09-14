$ErrorActionPreference = 'Stop'

$policyKeys = @(
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
)
$policyKeys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

#

Write-Host 'File Explorer Policy : Do not add shares of recently opened documents to Network Locations : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name NoRecentDocsNetHood -Value 1 -Type DWord

Write-Host 'File Explorer : Prevent the conversion of the path to all lowercase characters : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name DontPrettyPath -Value 1 -Type DWord

$osVersion = [System.Environment]::OSVersion.Version

# Folder Options : General

if ($osVersion.Major -ge 10) {
    Write-Host 'Folder Options : General : Open File Explorer to This PC...'
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer' -Name LaunchTo -Value 1 -Type DWord
}

Write-Host 'Folder Options : General : Browse folders: open each folder in the same window'
# See: https://learn.microsoft.com/en-us/windows/win32/api/shlobj_core/ns-shlobj_core-cabinetstate
# Data:
#   offset 0x04, 4 bytes (0x0000010b) : fFullPathTitle, fSaveLocalView, fSimpleDefault, fAdminsCreateCommonGroups
$cabinetStateSettings = [byte[]](0x0c, 0x00, 0x02, 0x00, 0x0b, 0x01, 0x00, 0x00, 0x60, 0x00, 0x00, 0x00)
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState' -Name Settings -Value $cabinetStateSettings -Type Binary

Write-Host 'Folder Options : General : Click items as follows: Double-click to open an item (single-click to select)'
# See: https://learn.microsoft.com/en-us/windows/win32/api/shlobj_core/ns-shlobj_core-shellstatea
# Data:
#   offset 0x00, 4 bytes (0x00000024) : Size
#   offset 0x04, 4 bytes (0x00002927) : fShowAllObjects, fShowExtensions, fNoConfirmRecycle, fDoubleClickInWebView, fDontPrettyPath, fShowInfoTip, fWebView
#   offset 0x14, 4 bytes (0x00000001) : iSortDirection
#   offset 0x18, 4 bytes (0x00000013) : version (Windows 7: 0x00000012)
#   offset 0x20, 4 bytes (0x00000062) : fStartPanelOn, fShowTypeOverlay, fShowStatusBar (Windows 8+) (Windows 7: 0x00000022)
$shellState = [byte[]](
    0x24, 0x00, 0x00, 0x00,
    0x27, 0x29, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00,
    0x01, 0x00, 0x00, 0x00,
    0x13, 0x00, 0x00, 0x00, # 0x12, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00,
    0x62, 0x00, 0x00, 0x00  # 0x22, 0x00, 0x00, 0x00
)

if (($osVersion.Major -eq 6) -and ($osVersion.Minor -le 1) ) {
    $shellState[0x18] = 0x12
    $shellState[0x20] = 0x22
}

Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer' -Name ShellState -Value $shellState -Type Binary

if ($osVersion.Major -ge 10) {
    Write-Host 'Folder Options : General : Privacy : Show recently used files in Quick Access : Disabled'
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer' -Name ShowRecent -Value 0 -Type DWord

    Write-Host 'Folder Options : General : Privacy : Show frequently used folders in Quick Access : Disabled'
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer' -Name ShowFrequent -Value 0 -Type DWord
}

#-------------------------------------------------------------------------------

# Folder Options : View

Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name WebView -Value 1 -Type DWord

Write-Host 'Folder Options : View : Files and Folders : Always show icons, never thumbnails : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name IconsOnly -Value 0 -Type DWord

Write-Host 'Folder Options : View : Files and Folders : Always show menus : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name AlwaysShowMenus -Value 0 -Type DWord

Write-Host 'Folder Options : View : Files and Folders : Display file icon on thumbnails : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name ShowTypeOverlay -Value 1 -Type DWord

Write-Host 'Folder Options : View : Files and Folders : Display file size information in folder tips : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name FolderContentsInfoTip -Value 1 -Type DWord

Write-Host 'Folder Options : View : Files and Folders : Display the full path in the title bar : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState' -Name FullPath -Value 1 -Type DWord

Write-Host 'Folder Options : View : Files and Folders : Hidden files and folders: Show hidden files, folders and drives : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name Hidden -Value 1 -Type DWord

Write-Host 'Folder Options : View : Files and Folders : Hide empty drives : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name HideDrivesWithNoMedia -Value 1 -Type DWord

Write-Host 'Folder Options : View : Files and Folders : Hide extensions for known file types : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name HideFileExt -Value 0 -Type DWord

if (($osVersion.Major -ge 10) -or (($osVersion.Major -eq 6) -and ($osVersion.Minor -ge 2))) {
    Write-Host 'Folder Options : View : Files and Folders : Hide folder merge conflicts : Enabled'
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name HideMergeConflicts -Value 1 -Type DWord
}

Write-Host 'Folder Options : View : Files and Folders : Hide protected operating system files : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name ShowSuperHidden -Value 0 -Type DWord

Write-Host 'Folder Options : View : Files and Folders : Launch folder windows in a separate process : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name SeparateProcess -Value 0 -Type DWord

Write-Host 'Folder Options : View : Files and Folders : Restore previous folder windows at logon : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name PersistBrowsers -Value 0 -Type DWord

Write-Host 'Folder Options : View : Files and Folders : Show drive letters : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer' -Name ShowDriveLettersFirst -Value 0 -Type DWord

Write-Host 'Folder Options : View : Files and Folders : Show encrypted or compressed NTFS files in color : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name ShowCompColor -Value 0 -Type DWord

if ($osVersion.Major -ge 10) {
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name ShowEncryptCompressedColor -Value 0 -Type DWord
}

Write-Host 'Folder Options : View : Files and Folders : Show pop-up description for folder and desktop items : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name ShowInfoTip -Value 1 -Type DWord

Write-Host 'Folder Options : View : Files and Folders : Show preview handlers in preview pane : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name ShowPreviewHandlers -Value 1 -Type DWord

if (($osVersion.Major -ge 10) -or (($osVersion.Major -eq 6) -and ($osVersion.Minor -ge 2))) {
    Write-Host 'Folder Options : View : Files and Folders : Show status bar : Enabled'
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name ShowStatusBar -Value 1 -Type DWord
}

if ($osVersion.Major -ge 10) {
    Write-Host 'Folder Options : View : Files and Folders : Show sync provider notifications : Enabled'
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name ShowSyncProviderNotifications -Value 1 -Type DWord
}

Write-Host 'Folder Options : View : Files and Folders : Use check boxes to select items : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name AutoCheckSelect -Value 0 -Type DWord

Write-Host 'Folder Options : View : Files and Folders : Use Sharing Wizard : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name SharingWizardOn -Value 1 -Type DWord

Write-Host 'Folder Options : View : Files and Folders : When typing into list view: select the typed item in the view'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name TypeAhead -Value 0 -Type DWord

#-------------------------------------------------------------------------------

$settingKeys = @(
    'HKCU:\Software\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}'
)
$settingKeys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

#

# Folder Options : Navigation pane

if (($osVersion.Major -ge 10) -or (($osVersion.Major -eq 6) -and ($osVersion.Minor -ge 2))) {
    Write-Host 'Folder Options : Navigation pane : Show libraries : Disabled'
    Set-ItemProperty -Path 'HKCU:\Software\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}' -Name System.IsPinnedToNameSpaceTree -Value 0 -Type DWord
}

if (($osVersion.Major -eq 6) -and ($osVersion.Minor -ge 2)) {
    Write-Host 'Folder Options : Navigation pane : Show favorites : Disabled'
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name NavPaneShowFavorites -Value 0 -Type DWord
}

if ($osVersion.Major -ge 10) {
    Write-Host 'Folder Options : Navigation pane : Always show availablity status : Disabled'
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name NavPaneShowAllCloudStates -Value 0 -Type DWord
}

Write-Host 'Folder Options : Navigation pane : Show all folders : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name NavPaneShowAllFolders -Value 0 -Type DWord

Write-Host 'Folder Options : Navigation pane : Expand to open folder : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name NavPaneExpandToCurrentFolder -Value 0 -Type DWord

#-------------------------------------------------------------------------------
