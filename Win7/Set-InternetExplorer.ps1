$ErrorActionPreference = 'Stop'

$Key = 'HKCU:\SOFTWARE\Microsoft\Internet Explorer\Main\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null

Write-Host 'Internet Explorer : Prevent show first run customize dialog boxes : Enabled'
New-ItemProperty -Path $Key -Name DisableFirstRunCustomize -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Internet Explorer : Setting Home Page to about:blank'
New-ItemProperty -Path $Key -Name 'Start Page' -Value 'about:blank' -PropertyType String -Force | Out-Null

Write-Host 'Internet Explorer : Automatically check new versions of stored pages...'
New-ItemProperty -Path $Key -Name Cache_Update_Frequency -Value yes -PropertyType String -Force | Out-Null

Write-Host 'Internet Explorer : Save last session on exit : Disabled'
New-ItemProperty -Path $Key -Name Save_Session_History_On_Exit -Value no -PropertyType String -Force | Out-Null

Write-Host 'Internet Explorer : Use clear type : Enabled'
New-ItemProperty -Path $Key -Name UseClearType -Value yes -PropertyType String -Force | Out-Null

Write-Host 'Internet Explorer : FullScreen Mode : Disabled'
New-ItemProperty -Path $Key -Name FullScreen -Value no -PropertyType String -Force | Out-Null

Write-Host 'Internet Explorer : Auto complete forms and passwords : Disabled'
New-ItemProperty -Path $Key -Name 'Use FormSuggest' -Value no -PropertyType String -Force | Out-Null
New-ItemProperty -Path $Key -Name 'FormSuggest PW Ask' -Value no -PropertyType String -Force | Out-Null
New-ItemProperty -Path $Key -Name 'FormSuggest Passwords' -Value no -PropertyType String -Force | Out-Null

#

$Key = 'HKCU:\SOFTWARE\Microsoft\Internet Explorer\IntelliForms\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name AskUser -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name PSMigrated -Value 1 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Internet Explorer : Suggested Sites : Disabled'
$Key = 'HKCU:\SOFTWARE\Microsoft\Internet Explorer\Suggested Sites\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name Enabled -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name DataStreamEnabledState -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Internet Explorer : Links Bar : Disabled'
$Key = 'HKCU:\SOFTWARE\Microsoft\Internet Explorer\LinksBar\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name Enabled -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Internet Explorer : Restore last session at launch : Disabled'
$Key = 'HKCU:\SOFTWARE\Microsoft\Internet Explorer\ContinuousBrowsing\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name Enabled -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Internet Explorer : Never allow web sites to request your physical location : Enabled'
$Key = 'HKCU:\SOFTWARE\Microsoft\Internet Explorer\Geolocation\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name BlockAllWebsites -Value 1 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Internet Explorer : Lock the toolbar : Enabled'
$Key = 'HKCU:\SOFTWARE\Microsoft\Internet Explorer\Toolbar\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name Locked -Value 1 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Internet Explorer : Clean browsing history on exit : Enabled'
$Key = 'HKCU:\SOFTWARE\Microsoft\Internet Explorer\Privacy\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name CleanDownloadHistory -Value 1 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name CleanForms -Value 1 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name CleanInPrivateBlocking -Value 1 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name CleanPassword -Value 1 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name CleanTrackingProtection -Value 1 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name ClearBrowsingHistoryOnExit -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name UseAllowList -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Internet Explorer : Let Internet Explorer decide how pop-ups should open : Enabled'
$Key = 'HKCU:\SOFTWARE\Microsoft\Internet Explorer\New Windows\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name PopupMgr -Value 1 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

$Key = 'HKCU:\SOFTWARE\Microsoft\Internet Explorer\TabbedBrowsing\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null

Write-Host 'Internet Explorer : Use Tabbed Browsing : Enabled'
New-ItemProperty -Path $Key -Name Enabled -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Internet Explorer : Warn me when closing multiple tabs : Enabled'
New-ItemProperty -Path $Key -Name WarnOnClose -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Internet Explorer : Show previews for individual tabs in the taskbar : Enabled'
New-ItemProperty -Path $Key -Name ThumbnailBehavior -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Internet Explorer : Group Tabs : Enabled'
New-ItemProperty -Path $Key -Name Groups -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Internet Explorer : Open only the first home page when Internet Explorer starts : Enabled'
New-ItemProperty -Path $Key -Name OpenAllHomePages -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'Internet Explorer : Open new tab in foreground : Enabled'
New-ItemProperty -Path $Key -Name OpenInForeground -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Internet Explorer : When a new tab opened, open a blank page...'
New-ItemProperty -Path $Key -Name NewTabPageShow -Value 3 -PropertyType DWord -Force | Out-Null

Write-Host 'Internet Explorer : Open links from other programs in a new tab in the current window...'
New-ItemProperty -Path $Key -Name ShortcutBehavior -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Internet Explorer : Pop-ups use new window : Disabled'
New-ItemProperty -Path $Key -Name PopupsUseNewWindow -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

if ([System.Environment]::OSVersion.Version.Major -eq 6) {
    $Key = 'HKCU:\SOFTWARE\Microsoft\Internet Explorer\Main\'
    (Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null

    Write-Host 'Internet Explorer : Check associations on starts : Disabled'
    New-ItemProperty -Path $Key -Name Check_Associations -Value no -PropertyType String -Force | Out-Null

    Write-Host 'Internet Explorer : Notify download complete : Disabled'
    New-ItemProperty -Path $Key -Name NotifyDownloadComplete -Value no -PropertyType String -Force | Out-Null

    Write-Host 'Internet Explorer : Always show menus : Disabled'
    New-ItemProperty -Path $Key -Name AlwaysShowMenus -Value 0 -PropertyType DWord -Force | Out-Null

    Write-Host 'Internet Explorer : Always send 'DoNotTrack" : Enabled"
    New-ItemProperty -Path $Key -Name DoNotTrack -Value 1 -PropertyType DWord -Force | Out-Null

    Write-Host 'Internet Explorer : Prevent check updates : Enabled'
    New-ItemProperty -Path $Key -Name NoUpdateCheck -Value 1 -PropertyType DWord -Force | Out-Null
}
