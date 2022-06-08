$ErrorActionPreference = "Stop"

Write-Host "Windows Store : Turn off Automatic Download and Install of updates : Enabled"
$Key = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name AutoDownload -Value 2 -PropertyType DWord -Force
