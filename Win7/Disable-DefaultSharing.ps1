$ErrorActionPreference = 'Stop'

$Key = 'HKLM:\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters\'

Write-Host 'System Network : Default Sharing : Disabled'
New-ItemProperty -Path $Key -Name AutoShareServer -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name AutoShareWks -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'System Network : Restrct null session access : Enabled'
New-ItemProperty -Path $Key -Name RestrictNullSessAccess -Value 1 -PropertyType DWord -Force | Out-Null
