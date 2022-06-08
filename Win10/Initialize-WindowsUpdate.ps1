$ErrorActionPreference = "Stop"

Write-Host "Windows Update : Do not include drivers with Windows Updates : Enabled"
$Key = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name ExcludeWUDriversInQualityUpdate -Value 1 -PropertyType DWord -Force
