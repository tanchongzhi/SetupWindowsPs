$ErrorActionPreference = 'Stop'

$Key = 'HKLM:\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters\'

Write-Host 'Default Sharing : Disabled'
New-ItemProperty -Path $Key -Name AutoShareServer -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name AutoShareWks -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'System Network : Restrct null session access : Enabled'
New-ItemProperty -Path $Key -Name RestrictNullSessAccess -Value 1 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

$Key = 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\'

Write-Host 'System Network : Restrict anonymous access to named pipes and shares : Enabled'
New-ItemProperty -Path $Key -Name RestrictAnonymous -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'System Network : Restrict anonymous sam access to named pipes and shares : Enabled'
New-ItemProperty -Path $Key -Name RestrictAnonymousSam -Value 1 -PropertyType DWord -Force | Out-Null
