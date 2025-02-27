$ErrorActionPreference = 'Stop'

$Key = 'HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl\'

Write-Host 'Crash Control : Write an event to system log : Enabled'
New-ItemProperty -Path $Key -Name LogEvent -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Crash Control : Write debugging information : Small memory dump (64KB)'
New-ItemProperty -Path $Key -Name CrashDumpEnabled -Value 3 -PropertyType DWord -Force | Out-Null

Write-Host 'Crash Control : Small memory dump directory : %SystemRoot%\Minidump'
New-ItemProperty -Path $Key -Name MinidumpDir -Value '%SystemRoot%\Minidump' -PropertyType ExpandString -Force | Out-Null

Write-Host 'Crash Control : Small memory dump count : 50'
New-ItemProperty -Path $Key -Name MinidumpsCount -Value 50 -PropertyType DWord -Force | Out-Null

Write-Host 'Crash Control : Overwrite old memory dump : Enabled'
New-ItemProperty -Path $Key -Name Overwrite -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Crash Control : Automatically restart : Enabled'
New-ItemProperty -Path $Key -Name AutoReboot -Value 1 -PropertyType DWord -Force | Out-Null
