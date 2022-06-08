$ErrorActionPreference = "Stop"

$Key = "HKLM:\System\CurrentControlSet\services\LanmanServer\Parameters\"

Write-Host "Default Sharing : Disabled"
$null = New-ItemProperty -Path $Key -Name AutoShareServer -Value 0 -PropertyType DWord -Force
$null = New-ItemProperty -Path $Key -Name AutoShareWks -Value 0 -PropertyType DWord -Force

Write-Host "System Network : Restrct null session access : Enabled"
$null = New-ItemProperty -Path $Key -Name RestrictNullSessAccess -Value 1 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

$Key = "HKLM:\System\CurrentControlSet\Control\Lsa\"

Write-Host "System Network : Restrict anonymous access to named pipes and shares : Enabled"
$null = New-ItemProperty -Path $Key -Name RestrictAnonymous -Value 1 -PropertyType DWord -Force

Write-Host "System Network : Restrict anonymous sam access to named pipes and shares : Enabled"
$null = New-ItemProperty -Path $Key -Name RestrictAnonymousSam -Value 1 -PropertyType DWord -Force
