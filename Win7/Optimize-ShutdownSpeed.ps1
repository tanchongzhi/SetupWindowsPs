$ErrorActionPreference = 'Stop'

$WaitTimeout = 5000

Write-Host 'Decreases system wait to kill timeout to make logs off or shutdown faster...'

$Key = 'HKCU:\Control Panel\Desktop\'
New-ItemProperty -Path $Key -Name AutoEndTasks -Value 1 -PropertyType String -Force | Out-Null
New-ItemProperty -Path $Key -Name HungAppTimeout -Value $WaitTimeout -PropertyType String -Force | Out-Null
New-ItemProperty -Path $Key -Name WaitToKillAppTimeout -Value $WaitTimeout -PropertyType String -Force | Out-Null

#

$Key = 'HKLM:\SYSTEM\CurrentControlSet\Control\'
New-ItemProperty -Path $Key -Name WaitToKillServiceTimeout -Value $WaitTimeout -PropertyType String -Force | Out-Null
