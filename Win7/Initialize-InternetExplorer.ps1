$ErrorActionPreference = "Stop"

$Key = "HKCU:\Software\Microsoft\Internet Explorer\Main\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)

Write-Host "Internet Explorer : Prevent show first run customize dialog boxes : Enabled"
$null = New-ItemProperty -Path $Key -Name DisableFirstRunCustomize -Value 1 -PropertyType DWord -Force

Write-Host "Internet Explorer : Setting Home Page to about:blank"
$null = New-ItemProperty -Path $Key -Name "Start Page" -Value "about:blank" -PropertyType String -Force

Write-Host "Internet Explorer : Automatically check new versions of stored pages..."
$null = New-ItemProperty -Path $Key -Name Cache_Update_Frequency -Value yes -PropertyType String -Force

Write-Host "Internet Explorer : Save last session on exit : Disabled"
$null = New-ItemProperty -Path $Key -Name Save_Session_History_On_Exit -Value no -PropertyType String -Force

Write-Host "Internet Explorer : Use clear type : Enabled"
$null = New-ItemProperty -Path $Key -Name UseClearType -Value yes -PropertyType String -Force

Write-Host "Internet Explorer : FullScreen Mode : Disabled"
$null = New-ItemProperty -Path $Key -Name FullScreen -Value no -PropertyType String -Force

Write-Host "Internet Explorer : Auto complete forms and passwords : Disabled"
$null = New-ItemProperty -Path $Key -Name "Use FormSuggest" -Value no -PropertyType String -Force
$null = New-ItemProperty -Path $Key -Name "FormSuggest PW Ask" -Value no -PropertyType String -Force
$null = New-ItemProperty -Path $Key -Name "FormSuggest Passwords" -Value no -PropertyType String -Force

#

$Key = "HKCU:\Software\Microsoft\Internet Explorer\IntelliForms\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name AskUser -Value 0 -PropertyType DWord -Force
$null = New-ItemProperty -Path $Key -Name PSMigrated -Value 1 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "Internet Explorer : Suggested Sites : Disabled"
$Key = "HKCU:\Software\Microsoft\Internet Explorer\Suggested Sites\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name Enabled -Value 0 -PropertyType DWord -Force
$null = New-ItemProperty -Path $Key -Name DataStreamEnabledState -Value 0 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "Internet Explorer : Links Bar : Disabled"
$Key = "HKCU:\Software\Microsoft\Internet Explorer\LinksBar\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name Enabled -Value 0 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "Internet Explorer : Restore last session at launch : Disabled"
$Key = "HKCU:\Software\Microsoft\Internet Explorer\ContinuousBrowsing\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name Enabled -Value 0 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "Internet Explorer : Never allow web sites to request your physical location : Enabled"
$Key = "HKCU:\Software\Microsoft\Internet Explorer\Geolocation\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name BlockAllWebsites -Value 1 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "Internet Explorer : Lock the toolbar : Enabled"
$Key = "HKCU:\Software\Microsoft\Internet Explorer\Toolbar\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name Locked -Value 1 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "Internet Explorer : Clean browsing history on exit : Enabled"
$Key = "HKCU:\Software\Microsoft\Internet Explorer\Privacy\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name CleanDownloadHistory -Value 1 -PropertyType DWord -Force
$null = New-ItemProperty -Path $Key -Name CleanForms -Value 1 -PropertyType DWord -Force
$null = New-ItemProperty -Path $Key -Name CleanInPrivateBlocking -Value 1 -PropertyType DWord -Force
$null = New-ItemProperty -Path $Key -Name CleanPassword -Value 1 -PropertyType DWord -Force
$null = New-ItemProperty -Path $Key -Name CleanTrackingProtection -Value 1 -PropertyType DWord -Force
$null = New-ItemProperty -Path $Key -Name ClearBrowsingHistoryOnExit -Value 0 -PropertyType DWord -Force
$null = New-ItemProperty -Path $Key -Name UseAllowList -Value 0 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "Internet Explorer : Let Internet Explorer decide how pop-ups should open : Enabled"
$Key = "HKCU:\Software\Microsoft\Internet Explorer\New Windows\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name PopupMgr -Value 1 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

$Key = "HKCU:\Software\Microsoft\Internet Explorer\TabbedBrowsing\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)

Write-Host "Internet Explorer : Use Tabbed Browsing : Enabled"
$null = New-ItemProperty -Path $Key -Name Enabled -Value 1 -PropertyType DWord -Force

Write-Host "Internet Explorer : Warn me when closing multiple tabs : Enabled"
$null = New-ItemProperty -Path $Key -Name WarnOnClose -Value 1 -PropertyType DWord -Force

Write-Host "Internet Explorer : Show previews for individual tabs in the taskbar : Enabled"
$null = New-ItemProperty -Path $Key -Name ThumbnailBehavior -Value 1 -PropertyType DWord -Force

Write-Host "Internet Explorer : Group Tabs : Enabled"
$null = New-ItemProperty -Path $Key -Name Groups -Value 1 -PropertyType DWord -Force

Write-Host "Internet Explorer : Open only the first home page when Internet Explorer starts : Enabled"
$null = New-ItemProperty -Path $Key -Name OpenAllHomePages -Value 0 -PropertyType DWord -Force

Write-Host "Internet Explorer : Open new tab in foreground : Enabled"
$null = New-ItemProperty -Path $Key -Name OpenInForeground -Value 1 -PropertyType DWord -Force

Write-Host "Internet Explorer : When a new tab opened, open a blank page..."
$null = New-ItemProperty -Path $Key -Name NewTabPageShow -Value 3 -PropertyType DWord -Force

Write-Host "Internet Explorer : Open links from other programs in a new tab in the current window..."
$null = New-ItemProperty -Path $Key -Name ShortcutBehavior -Value 1 -PropertyType DWord -Force

Write-Host "Internet Explorer : Pop-ups use new window : Disabled"
$null = New-ItemProperty -Path $Key -Name PopupsUseNewWindow -Value 0 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

if ([System.Environment]::OSVersion.Version.Major -eq 6) {
    $Key = "HKCU:\Software\Microsoft\Internet Explorer\Main\"
    $null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)

    Write-Host "Internet Explorer : Check associations on starts : Disabled"
    $null = New-ItemProperty -Path $Key -Name Check_Associations -Value no -PropertyType String -Force

    Write-Host "Internet Explorer : Notify download complete : Disabled"
    $null = New-ItemProperty -Path $Key -Name NotifyDownloadComplete -Value no -PropertyType String -Force

    Write-Host "Internet Explorer : Always show menus : Disabled"
    $null = New-ItemProperty -Path $Key -Name AlwaysShowMenus -Value 0 -PropertyType DWord -Force

    Write-Host "Internet Explorer : Always send "DoNotTrack" : Enabled"
    $null = New-ItemProperty -Path $Key -Name DoNotTrack -Value 1 -PropertyType DWord -Force

    Write-Host "Internet Explorer : Prevent check updates : Enabled"
    $null = New-ItemProperty -Path $Key -Name NoUpdateCheck -Value 1 -PropertyType DWord -Force
}
