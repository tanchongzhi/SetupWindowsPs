$ErrorActionPreference = 'Stop'

Write-Host 'Internet Explorer Policies : Allow Microsoft services to provide enhanced suggestions as the user types in the Address bar : Disabled'
$Keys = @(
    'HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\',
    'HKCU:\SOFTWARE\Policies\Microsoft\Internet Explorer\'
)
$Keys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null
New-ItemProperty -Path $Keys -Name AllowServicePoweredQSA -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

$Keys = @(
    'HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main\',
    'HKCU:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main\'
)
$Keys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

Write-Host 'Internet Explorer Policies : Prevent running First Run wizard : Enabled'
New-ItemProperty -Path $Keys -Name DisableFirstRunCustomize -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Internet Explorer Policies : Hide Internet Explorer 11 retirement notification : Disabled'
New-ItemProperty -Path $Keys -Name DisableIEAppNotificationPolicy -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

$Keys = @(
    'HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main\WindowsSearch\',
    'HKCU:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main\WindowsSearch\'
)
$Keys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

Write-Host 'Internet Explorer Policies : Turn off Windows Search AutoComplete : Disabled'
New-ItemProperty -Path $Keys -Name EnabledScopes -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Internet Explorer Policies : Turn off suggestions for all user-installed providers : Enabled'
$Keys = @(
    'HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\SearchScopes\',
    'HKCU:\SOFTWARE\Policies\Microsoft\Internet Explorer\SearchScopes\'
)
$Keys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null
New-ItemProperty -Path $Keys -Name ShowSearchSuggestionsGlobal -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Internet Explorer Policies : Prevent participation in the Customer Experience Improvement Program : Enabled'
$Keys = @(
    'HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\SQM\',
    'HKCU:\SOFTWARE\Policies\Microsoft\Internet Explorer\SQM\'
)
$Keys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null
New-ItemProperty -Path $Keys -Name DisableCustomerImprovementProgram -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Internet Explorer Policies : Turn on Suggested Sites : Enabled'
$Keys = @(
    'HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Suggested Sites\',
    'HKCU:\SOFTWARE\Policies\Microsoft\Internet Explorer\Suggested Sites\'
)
$Keys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null
New-ItemProperty -Path $Keys -Name Enabled -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

$Keys = @(
    'HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\TabbedBrowsing\',
    'HKCU:\SOFTWARE\Policies\Microsoft\Internet Explorer\TabbedBrowsing\'
)
$Keys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

Write-Host 'Internet Explorer Policies : Specify default behavior for a new tab (about:blank) : Enabled'
New-ItemProperty -Path $Keys -Name NewTabPageShow -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'Internet Explorer Policies : Turn off Quick Tabs functionality : Enabled'
New-ItemProperty -Path $Keys -Name QuickTabsThreshold -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Internet Explorer Policies : Turn off Reopen Last Browsing Session : Enabled'
$Keys = @(
    'HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Recovery\',
    'HKCU:\SOFTWARE\Policies\Microsoft\Internet Explorer\Recovery\'
)
$Keys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null
New-ItemProperty -Path $Keys -Name NoReopenLastSession -Value 1 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

$Key = 'HKCU:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null

Write-Host 'Internet Explorer Policies : Notify users if Internet Explorer is not the default web browser : Enabled'
New-ItemProperty -Path $Key -Name Check_Associations -Value no -PropertyType String -Force | Out-Null

Write-Host 'Internet Explorer Policies : Disable AutoComplete for forms and passwords: Enabled'
New-ItemProperty -Path $Key -Name 'Use FormSuggest' -Value no -PropertyType String -Force | Out-Null
New-ItemProperty -Path $Key -Name 'FormSuggest Passwords' -Value no -PropertyType String -Force | Out-Null
New-ItemProperty -Path $Key -Name 'FormSuggest PW Ask' -Value no -PropertyType String -Force | Out-Null

$Key = 'HKCU:\SOFTWARE\Policies\Microsoft\Internet Explorer\Control Panel\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name FormSuggest -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name 'FormSuggest Passwords' -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Internet Explorer : Disable AutoComplete for forms and passwords: Enabled'

$Key = 'HKCU:\SOFTWARE\Microsoft\Internet Explorer\Main\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name 'Use FormSuggest' -Value no -PropertyType String -Force | Out-Null
New-ItemProperty -Path $Key -Name 'FormSuggest Passwords' -Value no -PropertyType String -Force | Out-Null
New-ItemProperty -Path $Key -Name 'FormSuggest PW Ask' -Value no -PropertyType String -Force | Out-Null

#-------------------------------------------------------------------------------

$Key = 'HKCU:\SOFTWARE\Microsoft\Internet Explorer\Main\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null

Write-Host 'Internet Explorer: Specify default start page (about:blank) : Enabled'
New-ItemProperty -Path $Key -Name 'Start Page' -Value 'about:blank' -PropertyType String -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Internet Explorer : Clear browsing history on exit : Enabled'
$Key = 'HKCU:\SOFTWARE\Microsoft\Internet Explorer\Privacy\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name CleanDownloadHistory -Value 1 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name CleanForms -Value 1 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name CleanPassword -Value 1 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name CleanTrackingProtection -Value 1 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name ClearBrowsingHistoryOnExit -Value 1 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name UseAllowList -Value 0 -PropertyType DWord -Force | Out-Null
