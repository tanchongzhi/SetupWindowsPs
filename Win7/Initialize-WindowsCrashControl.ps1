$ErrorActionPreference = "Stop"

$Key = "HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl\"

Write-Host "Crash Control : Write an event to system log : Enabled"
$null = New-ItemProperty -Path $Key -Name LogEvent -Value 1 -PropertyType DWord -Force

Write-Host "Crash Control : Write debugging information : Small memory dump (64KB)"
$null = New-ItemProperty -Path $Key -Name CrashDumpEnabled -Value 3 -PropertyType DWord -Force

Write-Host "Crash Control : Small memory dump directory : %SystemRoot%\Minidump"
$null = New-ItemProperty -Path $Key -Name MinidumpDir -Value "%SystemRoot%\Minidump" -PropertyType ExpandString -Force

Write-Host "Crash Control : Small memory dump count : 50"
$null = New-ItemProperty -Path $Key -Name MinidumpsCount -Value 50 -PropertyType DWord -Force

Write-Host "Crash Control : Overwrite old memory dump : Enabled"
$null = New-ItemProperty -Path $Key -Name Overwrite -Value 1 -PropertyType DWord -Force

Write-Host "Crash Control : Automatically restart : Enabled"
$null = New-ItemProperty -Path $Key -Name AutoReboot -Value 1 -PropertyType DWord -Force
