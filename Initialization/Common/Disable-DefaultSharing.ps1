$ErrorActionPreference = 'Stop'

Write-Host 'System Network : Default Sharing : Disabled'
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\services\LanmanServer\Parameters' -Name AutoShareServer -Value 0 -Type DWord
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\services\LanmanServer\Parameters' -Name AutoShareWks -Value 0 -Type DWord
