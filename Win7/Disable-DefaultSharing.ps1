$ErrorActionPreference = "Stop"

$Key = "HKLM:\System\CurrentControlSet\services\LanmanServer\Parameters\"

Write-Host "System Network : Default Sharing : Disabled"
$null = New-ItemProperty -Path $Key -Name AutoShareServer -Value 0 -PropertyType DWord -Force
$null = New-ItemProperty -Path $Key -Name AutoShareWks -Value 0 -PropertyType DWord -Force

Write-Host "System Network : Restrct null session access : Enabled"
$null = New-ItemProperty -Path $Key -Name RestrictNullSessAccess -Value 1 -PropertyType DWord -Force
