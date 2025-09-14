$ErrorActionPreference = 'Stop'

Write-Host 'System Network : Restrct null session access : Enabled'
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\services\LanmanServer\Parameters' -Name RestrictNullSessAccess -Value 1 -Type DWord

Write-Host 'System Network : Restrict anonymous access to named pipes and shares : Enabled'
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Lsa' -Name RestrictAnonymous -Value 1 -Type DWord

Write-Host 'System Network : Restrict anonymous sam access to named pipes and shares : Enabled'
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Lsa' -Name RestrictAnonymousSam -Value 1 -Type DWord

Write-Host 'System Network : Limit local account use of blank passwords to console logon only : Enabled'
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Lsa' -Name LimitBlankPasswordUse -Value 1 -Type DWord
