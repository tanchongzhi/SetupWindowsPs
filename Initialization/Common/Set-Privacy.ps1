$ErrorActionPreference = 'Stop'

$policyKeys = @(
    'HKCU:\Software\Policies\Microsoft\Assistance\Client\1.0',
    'HKLM:\Software\Policies\Microsoft\SQMClient\Windows'
)
$policyKeys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

#

Write-Host 'Privacy Policy : Turn off Help Experience Improvement Program : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Assistance\Client\1.0' -Name NoExplicitFeedback -Value 1 -Type DWord

Write-Host 'Privacy Policy : Turn off Windows Customer Experience Improvement Program : Enabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\SQMClient\Windows' -Name CEIPEnable -Value 0 -Type DWord

Write-Host 'Privacy : Turn off Windows Customer Experience Improvement Program : Enabled'
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\SQMClient\Windows' -Name CEIPEnable -Value 0 -Type DWord

Write-Host 'Privacy : Scheduled Tasks : \Microsoft\Windows\Maintenance\WinSAT : Disabled'
$null = schtasks /Change /Disable /TN '\Microsoft\Windows\Maintenance\WinSAT'

$scheduledTasks = schtasks /Query /FO LIST

Write-Host 'Privacy : Scheduled Tasks : \Microsoft\Windows\Customer Experience Improvement Program\* : Disabled'
$null = $scheduledTasks |
    Select-String -Pattern '\Microsoft\Windows\Customer Experience Improvement Program\' -SimpleMatch |
    ForEach-Object { schtasks /Change /Disable /TN "$($_.Line.Split(':', 2)[1].Trim())" }

Write-Host 'Privacy : Scheduled Tasks : \Microsoft\Windows\Application Experience\* : Disabled'
$null = $scheduledTasks |
    Select-String -Pattern '\Microsoft\Windows\Application Experience\' -SimpleMatch |
    ForEach-Object { schtasks /Change /Disable /TN "$($_.Line.Split(':', 2)[1].Trim())" }

Write-Host 'Privacy : Scheduled Tasks : \Microsoft\Windows\DiskDiagnostic\* : Disabled'
$null = $scheduledTasks |
    Select-String -Pattern '\Microsoft\Windows\DiskDiagnostic\' -SimpleMatch |
    ForEach-Object { schtasks /Change /Disable /TN "$($_.Line.Split(':', 2)[1].Trim())" }

Write-Host 'Privacy : Service : Diagnostics Tracking Service (or "Connected User Experiences and Telemetry") : Disabled'
Stop-Service -Name DiagTrack -Force -ErrorAction SilentlyContinue
Set-Service -Name DiagTrack -Status Stopped -StartupType Disabled -ErrorAction SilentlyContinue
