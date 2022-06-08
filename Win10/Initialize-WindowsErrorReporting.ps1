$ErrorActionPreference = "Stop"

$Keys = @(
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting\",
    "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting\"
)
$Keys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

Write-Host "Windows Error Reporting : Do not send additional data : Enabled"
$null = New-ItemProperty -Path $Keys -Name DontSendAdditionalData -Value 1 -PropertyType DWord -Force

Write-Host "Windows Error Reporting : Automatically send memory dumps for OS-generated error reports : Disabled"
$null = New-ItemProperty -Path $Keys -Name AutoApproveOSDumps -Value 0 -PropertyType DWord -Force
