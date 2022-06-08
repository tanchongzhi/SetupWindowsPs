$ErrorActionPreference = "Stop"

Write-Host "Maps : Turn off Automatic Download and Update of Map Data : Enabled"
$Key = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Maps\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name AutoDownloadAndUpdateMapData -Value 0 -PropertyType DWord -Force
