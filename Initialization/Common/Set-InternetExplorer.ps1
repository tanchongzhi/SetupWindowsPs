$ErrorActionPreference = 'Stop'

$policyKeys = @(
    'HKLM:\Software\Policies\Microsoft\Internet Explorer',
    'HKCU:\Software\Policies\Microsoft\Internet Explorer',
    'HKCU:\Software\Policies\Microsoft\Internet Explorer\Control Panel',
    'HKLM:\Software\Policies\Microsoft\Internet Explorer\Main',
    'HKCU:\Software\Policies\Microsoft\Internet Explorer\Main',
    'HKLM:\Software\Policies\Microsoft\Internet Explorer\Main\WindowsSearch',
    'HKCU:\Software\Policies\Microsoft\Internet Explorer\Main\WindowsSearch',
    'HKLM:\Software\Policies\Microsoft\Internet Explorer\Recovery',
    'HKCU:\Software\Policies\Microsoft\Internet Explorer\Recovery',
    'HKLM:\Software\Policies\Microsoft\Internet Explorer\SearchScopes',
    'HKCU:\Software\Policies\Microsoft\Internet Explorer\SearchScopes',
    'HKLM:\Software\Policies\Microsoft\Internet Explorer\Suggested Sites',
    'HKCU:\Software\Policies\Microsoft\Internet Explorer\Suggested Sites',
    'HKLM:\Software\Policies\Microsoft\Internet Explorer\SQM',
    'HKCU:\Software\Policies\Microsoft\Internet Explorer\SQM',
    'HKLM:\Software\Policies\Microsoft\Internet Explorer\TabbedBrowsing',
    'HKCU:\Software\Policies\Microsoft\Internet Explorer\TabbedBrowsing'
)
$policyKeys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

#

Write-Host 'Internet Explorer Policy : Allow Microsoft services to provide enhanced suggestions as the user types in the Address bar : Disabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer' -Name AllowServicePoweredQSA -Value 0 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer' -Name AllowServicePoweredQSA -Value 0 -Type DWord

Write-Host 'Internet Explorer Policy : Hide Internet Explorer 11 retirement notification : Enabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\Main' -Name DisableIEAppNotificationPolicy -Value 1 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\Main' -Name DisableIEAppNotificationPolicy -Value 1 -Type DWord

Write-Host 'Internet Explorer Policy : Prevent running First Run wizard : Enabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\Main' -Name DisableFirstRunCustomize -Value 1 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\Main' -Name DisableFirstRunCustomize -Value 1 -Type DWord

Write-Host 'Internet Explorer Policy : Notify users if Internet Explorer is not the default web browser : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\Main' -Name Check_Associations -Value no -Type String

Write-Host 'Internet Explorer Policy : Disable AutoComplete for forms: Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\Main' -Name 'Use FormSuggest' -Value no -Type String
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\Control Panel' -Name FormSuggest -Value 1 -Type DWord

Write-Host 'Internet Explorer Policy : Turn on the auto-complete feature for user names and passwords on forms: Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\Main' -Name 'FormSuggest Passwords' -Value no -Type String
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\Main' -Name 'FormSuggest PW Ask' -Value no -Type String
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\Control Panel' -Name 'FormSuggest Passwords' -Value 1 -Type DWord

Write-Host 'Internet Explorer Policy : Turn off Windows Search AutoComplete : Disabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\Main\WindowsSearch' -Name EnabledScopes -Value 0 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\Main\WindowsSearch' -Name EnabledScopes -Value 0 -Type DWord

Write-Host 'Internet Explorer Policy : Turn off suggestions for all user-installed providers : Enabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\SearchScopes' -Name ShowSearchSuggestionsGlobal -Value 0 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\SearchScopes' -Name ShowSearchSuggestionsGlobal -Value 0 -Type DWord

Write-Host 'Internet Explorer Policy : Turn off Reopen Last Browsing Session : Enabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\Recovery' -Name NoReopenLastSession -Value 1 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\Recovery' -Name NoReopenLastSession -Value 1 -Type DWord

Write-Host 'Internet Explorer Policy : Turn on Suggested Sites : Disabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\Suggested Sites' -Name Enabled -Value 0 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\Suggested Sites' -Name Enabled -Value 0 -Type DWord

Write-Host 'Internet Explorer Policy : Prevent participation in the Customer Experience Improvement Program : Enabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\SQM' -Name DisableCustomerImprovementProgram -Value 0 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\SQM' -Name DisableCustomerImprovementProgram -Value 0 -Type DWord

Write-Host 'Internet Explorer Policy : Turn off Quick Tabs functionality : Enabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\TabbedBrowsing' -Name QuickTabsThreshold -Value 0 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\TabbedBrowsing' -Name QuickTabsThreshold -Value 0 -Type DWord

Write-Host 'Internet Explorer Policy : Specify default behavior for a new tab: "about:blank"'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Internet Explorer\TabbedBrowsing' -Name NewTabPageShow -Value 0 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Internet Explorer\TabbedBrowsing' -Name NewTabPageShow -Value 0 -Type DWord

#-------------------------------------------------------------------------------

$settingKeys = @(
    'HKCU:\Software\Microsoft\Internet Explorer\Main',
    'HKCU:\Software\Microsoft\Internet Explorer\Main\IntelliForms',
    'HKCU:\Software\Microsoft\Internet Explorer\Main\WindowsSearch',
    'HKCU:\Software\Microsoft\Internet Explorer\DomainSuggestion',
    'HKCU:\Software\Microsoft\Internet Explorer\Suggested Sites',
    'HKCU:\Software\Microsoft\Internet Explorer\Toolbar',
    'HKCU:\Software\Microsoft\Internet Explorer\LinksBar',
    'HKCU:\Software\Microsoft\Internet Explorer\New Windows',
    'HKCU:\Software\Microsoft\Internet Explorer\TabbedBrowsing',
    'HKCU:\Software\Microsoft\Internet Explorer\ContinuousBrowsing',
    'HKCU:\Software\Microsoft\Internet Explorer\Geolocation',
    'HKCU:\Software\Microsoft\Internet Explorer\Privacy',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete'
)
$settingKeys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

#

Write-Host 'Internet Explorer : AutoComplete : Forms: Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Main' -Name 'Use FormSuggest' -Value no -Type String
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Main' -Name 'FormSuggest Passwords' -Value no -Type String
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Main' -Name 'FormSuggest PW Ask' -Value no -Type String
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\IntelliForms' -Name AskUser -Value 0 -Type DWord

Write-Host 'Internet Explorer : AutoComplete : Use Windows Search in Address bar : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Main\WindowsSearch' -Name AutoCompleteGroups -Value 0 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Main\WindowsSearch' -Name EnabledScopes -Value 0 -Type DWord

Write-Host 'Internet Explorer : AutoComplete : Suggesting URLs in Address bar : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\DomainSuggestion' -Name Enabled -Value 0 -Type DWord

Write-Host 'Internet Explorer : AutoComplete : Address bar : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete' -Name AutoSuggest -Value yes -Type String

Write-Host 'Internet Explorer : Suggested Sites : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Suggested Sites' -Name Enabled -Value 0 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Suggested Sites' -Name DataStreamEnabledState -Value 0 -Type DWord

Write-Host 'Internet Explorer : Always show menus : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Main' -Name AlwaysShowMenus -Value 0 -Type DWord

Write-Host 'Internet Explorer : Lock the toolbar : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Toolbar' -Name Locked -Value 1 -Type DWord

Write-Host 'Internet Explorer : Links Bar : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\LinksBar' -Name Enabled -Value 0 -Type DWord

Write-Host 'Internet Explorer : Tabs : Use Tabbed Browsing : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\TabbedBrowsing' -Name Enabled -Value 1 -Type DWord

Write-Host 'Internet Explorer : Tabs : Warn me when closing multiple tabs : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\TabbedBrowsing' -Name WarnOnClose -Value 1 -Type DWord

Write-Host 'Internet Explorer : Tabs : Show previews for individual tabs in the taskbar : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\TabbedBrowsing' -Name ThumbnailBehavior -Value 0 -Type DWord

Write-Host 'Internet Explorer : Tabs : Group Tabs : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\TabbedBrowsing' -Name Groups -Value 0 -Type DWord

Write-Host 'Internet Explorer : Tabs : Open each new tab next to current tab : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\TabbedBrowsing' -Name NewTabNextToCurrent -Value 1 -Type DWord

Write-Host 'Internet Explorer : Tabs : Open only the first home page when Internet Explorer starts : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\TabbedBrowsing' -Name OpenAllHomePages -Value 0 -Type DWord

Write-Host 'Internet Explorer : Tabs : Open new tab in foreground : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\TabbedBrowsing' -Name OpenInForeground -Value 1 -Type DWord

Write-Host 'Internet Explorer : Tabs : When a new tab opened, open a blank page...'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\TabbedBrowsing' -Name NewTabPageShow -Value 3 -Type DWord

Write-Host 'Internet Explorer : Tabs : Open links from other programs in a new tab in the current window...'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\TabbedBrowsing' -Name ShortcutBehavior -Value 1 -Type DWord

Write-Host 'Internet Explorer : Tabs : When a pop-up is encountered, let Internet Explorer decide how pop-ups should open...'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\TabbedBrowsing' -Name PopupsUseNewWindow -Value 0 -Type DWord

Write-Host 'Internet Explorer : Specify default start page: "about:blank"'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Main' -Name 'Start Page' -Value 'about:blank' -Type String

Write-Host 'Internet Explorer : Let Internet Explorer decide how pop-ups should open : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\New Windows' -Name PopupMgr -Value 1 -Type DWord

Write-Host 'Internet Explorer : Restore last session at launch : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\ContinuousBrowsing' -Name Enabled -Value 0 -Type DWord

Write-Host 'Internet Explorer : Save last session on exit : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Main' -Name Save_Session_History_On_Exit -Value no -Type String

Write-Host 'Internet Explorer : Automatically check new versions of stored pages...'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Main' -Name Cache_Update_Frequency -Value yes -Type String

Write-Host 'Internet Explorer : Never allow web sites to request your physical location : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Geolocation' -Name BlockAllWebsites -Value 1 -Type DWord

Write-Host 'Internet Explorer : Always send "DoNotTrack" : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Main' -Name DoNotTrack -Value 1 -Type DWord

Write-Host 'Internet Explorer : Clear browsing history on exit : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Privacy' -Name CleanDownloadHistory -Value 1 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Privacy' -Name CleanForms -Value 1 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Privacy' -Name CleanPassword -Value 1 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Privacy' -Name CleanTrackingProtection -Value 1 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Privacy' -Name ClearBrowsingHistoryOnExit -Value 1 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Privacy' -Name UseAllowList -Value 0 -Type DWord

Write-Host 'Internet Explorer : Prevent check updates : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Main' -Name NoUpdateCheck -Value 1 -Type DWord

Write-Host 'Internet Explorer : Notify download complete : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Main' -Name NotifyDownloadComplete -Value no -Type String

Write-Host 'Internet Explorer : Use clear type : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Main' -Name UseClearType -Value yes -Type String

Write-Host 'Internet Explorer : Full Screen Mode : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Main' -Name FullScreen -Value no -Type String

Write-Host 'Internet Explorer : Prevent running First Run wizard : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Main' -Name DisableFirstRunCustomize -Value 1 -Type DWord

Write-Host 'Internet Explorer : Notify users if Internet Explorer is not the default web browser : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Main' -Name Check_Associations -Value no -Type String

$osVersion = [System.Environment]::OSVersion.Version

if ($osVersion.Major -eq 6) {
    Write-Host 'Internet Explorer : Use TLS 1.2 only'
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name SecureProtocols -Value 2048 -Type DWord
}

if ($osVersion.Major -ge 10) {
    Write-Host 'Internet Explorer : Use TLS 1.2 and TLS 1.3 only'
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name SecureProtocols -Value 10240 -Type DWord
}
