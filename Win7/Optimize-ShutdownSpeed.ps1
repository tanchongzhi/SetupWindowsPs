$ErrorActionPreference = "Stop"

$WaitTimeout = 5000

Write-Host "Decreases system wait to kill timeout to make logs off or shutdown faster..."

$Key = "HKCU:\Control Panel\Desktop\"
$null = New-ItemProperty -Path $Key -Name AutoEndTasks -Value 1 -PropertyType String -Force
$null = New-ItemProperty -Path $Key -Name HungAppTimeout -Value $WaitTimeout -PropertyType String -Force
$null = New-ItemProperty -Path $Key -Name WaitToKillAppTimeout -Value $WaitTimeout -PropertyType String -Force

#

$Key = "HKLM:\SYSTEM\CurrentControlSet\Control\"
$null = New-ItemProperty -Path $Key -Name WaitToKillServiceTimeout -Value $WaitTimeout -PropertyType String -Force
