$ErrorActionPreference = "Stop"

$Key = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)

Write-Host "Windows Search : Do not allow web search : Enabled"
$null = New-ItemProperty -Path $Key -Name DisableWebSearch -Value 1 -PropertyType DWord -Force

Write-Host "Windows Search : Don't search the web or display web results in Search : Enabled"
$null = New-ItemProperty -Path $Key -Name ConnectedSearchUseWeb -Value 0 -PropertyType DWord -Force

Write-Host "Windows Search : Don't search the web or display web results in Search over metered connections : Enabled"
$null = New-ItemProperty -Path $Key -Name ConnectedSearchUseWebOverMeteredConnections -Value 1 -PropertyType DWord -Force

Write-Host "Windows Search : Allow cloud search : Disabled"
$null = New-ItemProperty -Path $Key -Name AllowCloudSearch -Value 0 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "Windows Search : Turn off storage and display of search history : Enabled"
$Key = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name DisableSearchHistory -Value 1 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

$Key = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)

Write-Host "Windows Search : Disable Bing in Windows Search : Enabled"
$null = New-ItemProperty -Path $Key -Name BingSearchEnabled  -Value 0 -PropertyType DWord -Force

Write-Host "Windows Search : Don't show Search box on the taskbar : Enabled"
$null = New-ItemProperty -Path $Key -Name SearchboxTaskbarMode  -Value 0 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

$Key = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)

# Cloud Search
$null = New-ItemProperty -Path $Key -Name IsMSACloudSearchEnabled  -Value 0 -PropertyType DWord -Force
$null = New-ItemProperty -Path $Key -Name IsAADCloudSearchEnabled  -Value 0 -PropertyType DWord -Force

# Storage Search History
$null = New-ItemProperty -Path $Key -Name IsDeviceSearchHistoryEnabled  -Value 0 -PropertyType DWord -Force
