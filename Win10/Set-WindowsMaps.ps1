$ErrorActionPreference = 'Stop'

Write-Host 'Windows Maps Policies : Turn off Automatic Download and Update of Map Data : Enabled'
$Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Maps\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name AutoDownloadAndUpdateMapData -Value 0 -PropertyType DWord -Force | Out-Null
