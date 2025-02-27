$ErrorActionPreference = 'Stop'

$Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null

Write-Host 'Windows Search Policies : Allow cloud search : Disabled'
New-ItemProperty -Path $Key -Name AllowCloudSearch -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'Windows Search Policies : Do not allow web search : Enabled'
New-ItemProperty -Path $Key -Name DisableWebSearch -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host "Windows Search Policies : Don't search the web or display web results in Search : Enabled"
New-ItemProperty -Path $Key -Name ConnectedSearchUseWeb -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host "Windows Search Policies : Don't search the web or display web results in Search over metered connections : Enabled"
New-ItemProperty -Path $Key -Name ConnectedSearchUseWebOverMeteredConnections -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Windows Search Policies : Do not allow locations on removable drives to be added to libraries : Enabled'
New-ItemProperty -Path $Key -Name DisableRemovableDriveIndexing -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Windows Search Policies : Prevent indexing Microsoft Office Outlook : Enabled'
New-ItemProperty -Path $Key -Name PreventIndexingOutlook -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Windows Search Policies : Prevent indexing e-mail attachments : Enabled'
New-ItemProperty -Path $Key -Name PreventIndexingEmailAttachments -Value 1 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Windows Search Policies : Turn off storage and display of search history : Enabled'
$Key = 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name DisableSearchHistory -Value 1 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

$Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null

Write-Host 'Windows Search : Disable Bing in Windows Search : Enabled'
New-ItemProperty -Path $Key -Name BingSearchEnabled -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host "Windows Search : Don't show Search box on the taskbar : Enabled"
New-ItemProperty -Path $Key -Name SearchboxTaskbarMode -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name TraySearchBoxVisible -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name TraySearchBoxVisibleOnAnyMonitor -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name OnboardSearchboxOnTaskbar -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name OnboardSBEmode -Value 1 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

$Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null

# Cloud Search
Write-Host 'Windows Search : Allow Windows search to provide results from the apps that you are signed in to with your Microsoft account : Disabled'
New-ItemProperty -Path $Key -Name IsMSACloudSearchEnabled -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'Windows Search : Allow Windows search to provide results from the apps that you are signed in to with your work or school account : Disabled'
New-ItemProperty -Path $Key -Name IsAADCloudSearchEnabled -Value 0 -PropertyType DWord -Force | Out-Null

# Storage Search History
Write-Host 'Windows Search : Store your search history locally on this device : Disabled'
New-ItemProperty -Path $Key -Name IsDeviceSearchHistoryEnabled -Value 0 -PropertyType DWord -Force | Out-Null
