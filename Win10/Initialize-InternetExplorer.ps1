$ErrorActionPreference = "Stop"

Write-Host "Internet Explorer: Allow Microsoft services to provide enhanced suggestions as the user types in the Address bar : Disabled"
$Keys = @(
    "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\",
    "HKCU:\SOFTWARE\Policies\Microsoft\Internet Explorer\"
)
$Keys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null
$null = New-ItemProperty -Path $Keys -Name AllowServicePoweredQSA -Value 0 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

$Keys = @(
    "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main\",
    "HKCU:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main\"
)
$Keys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

Write-Host "Internet Explorer: Prevent running First Run wizard : Enabled"
$null = New-ItemProperty -Path $Keys -Name DisableFirstRunCustomize -Value 1 -PropertyType DWord -Force

Write-Host "Internet Explorer: Hide Internet Explorer 11 retirement notification : Enabled"
$null = New-ItemProperty -Path $Keys -Name DisableIEAppNotificationPolicy -Value 1 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "Internet Explorer: Turn off suggestions for all user-installed providers : Enabled"
$Keys = @(
    "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\SearchScopes\",
    "HKCU:\SOFTWARE\Policies\Microsoft\Internet Explorer\SearchScopes\"
)
$Keys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null
$null = New-ItemProperty -Path $Keys -Name ShowSearchSuggestionsGlobal -Value 0 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "Internet Explorer: Prevent participation in the Customer Experience Improvement Program : Enabled"
$Keys = @(
    "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\SQM\",
    "HKCU:\SOFTWARE\Policies\Microsoft\Internet Explorer\SQM\"
)
$Keys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null
$null = New-ItemProperty -Path $Keys -Name DisableCustomerImprovementProgram -Value 0 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "Internet Explorer: Turn on Suggested Sites : Enabled"
$Keys = @(
    "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Suggested Sites\"
    "HKCU:\SOFTWARE\Policies\Microsoft\Internet Explorer\Suggested Sites\"
)
$Keys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null
$null = New-ItemProperty -Path $Keys -Name Enabled -Value 0 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

$Keys = @(
    "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\TabbedBrowsing\"
    "HKCU:\SOFTWARE\Policies\Microsoft\Internet Explorer\TabbedBrowsing\"
)
$Keys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

Write-Host "Internet Explorer: Specify default behavior for a new tab (about:blank) : Enabled"
$null = New-ItemProperty -Path $Keys -Name NewTabPageShow -Value 0 -PropertyType DWord -Force

Write-Host "Internet Explorer: Turn off Quick Tabs functionality : Enabled"
$null = New-ItemProperty -Path $Keys -Name QuickTabsThreshold -Value 0 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

$Key = "HKCU:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)

Write-Host "Internet Explorer: Notify users if Internet Explorer is not the default web browser : Enabled"
$null = New-ItemProperty -Path $Key -Name Check_Associations -Value no -PropertyType String -Force

Write-Host "Internet Explorer: Disable AutoComplete for forms and passwords: Enabled"
$null = New-ItemProperty -Path $Key -Name "Use FormSuggest" -Value no -PropertyType String -Force
$null = New-ItemProperty -Path $Key -Name "FormSuggest Passwords" -Value no -PropertyType String -Force
$null = New-ItemProperty -Path $Key -Name "FormSuggest PW Ask" -Value no -PropertyType String -Force

#

$Key = "HKCU:\SOFTWARE\Microsoft\Internet Explorer\Main\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name "Use FormSuggest" -Value no -PropertyType String -Force
$null = New-ItemProperty -Path $Key -Name "FormSuggest Passwords" -Value no -PropertyType String -Force
$null = New-ItemProperty -Path $Key -Name "FormSuggest PW Ask" -Value no -PropertyType String -Force

#

Write-Host "Internet Explorer: Specify default start page (about:blank) : Enabled"
$null = New-ItemProperty -Path $Key -Name "Start Page" -Value "about:blank" -PropertyType String -Force

#

$Key = "HKCU:\SOFTWARE\Policies\Microsoft\Internet Explorer\Control Panel\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name FormSuggest -Value 0 -PropertyType DWord -Force
$null = New-ItemProperty -Path $Key -Name "FormSuggest Passwords" -Value 0 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "Internet Explorer: Clear browsing history on exit : Enabled"
$Key = "HKCU:\SOFTWARE\Microsoft\Internet Explorer\Privacy\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name CleanDownloadHistory -Value 1 -PropertyType DWord -Force
$null = New-ItemProperty -Path $Key -Name CleanForms -Value 1 -PropertyType DWord -Force
$null = New-ItemProperty -Path $Key -Name CleanPassword -Value 1 -PropertyType DWord -Force
$null = New-ItemProperty -Path $Key -Name CleanTrackingProtection -Value 1 -PropertyType DWord -Force
$null = New-ItemProperty -Path $Key -Name ClearBrowsingHistoryOnExit -Value 1 -PropertyType DWord -Force
$null = New-ItemProperty -Path $Key -Name UseAllowList -Value 0 -PropertyType DWord -Force
