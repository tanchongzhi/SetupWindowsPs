$ErrorActionPreference = 'Stop'

Write-Host 'System : Automatically close non-responsive programs when sign out, restart, or shut down'
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name AutoEndTasks -Value 1 -Type String
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name HungAppTimeout -Value 5000 -Type String
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name WaitToKillAppTimeout -Value 15000 -Type String
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control' -Name WaitToKillServiceTimeout -Value 5000 -Type String
