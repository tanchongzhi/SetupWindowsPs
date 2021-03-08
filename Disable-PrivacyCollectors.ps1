$ErrorActionPreference = 'Stop'

if ($PSVersionTable.PSVersion.Major -eq 2) {
    $PSScriptRoot = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
}

if (-not (Get-Command -Name Get-ScheduledTask -ErrorAction SilentlyContinue) -or
    -not (Get-Command -Name Disable-ScheduledTask -ErrorAction SilentlyContinue)) {
    Import-Module -Name "$PSScriptRoot\Modules\ScheduledTasks.psm1" -Force
}

#-----------------------------------------------------------------------------------------------------------------------

Write-Host 'Scheduled Tasks : \Microsoft\Windows\Maintenance\WinSAT : Disabled'
Disable-ScheduledTask -TaskPath '\Microsoft\Windows\Maintenance\' -TaskName 'WinSAT'

Write-Host 'Scheduled Tasks : \Microsoft\Windows\Customer Experience Improvement Program\* : Disabled'
Get-ScheduledTask -TaskPath '\Microsoft\Windows\Customer Experience Improvement Program\' | Disable-ScheduledTask

Write-Host 'Scheduled Tasks : \Microsoft\Windows\Application Experience\* : Disabled'
Get-ScheduledTask -TaskPath '\Microsoft\Windows\Application Experience\' | Disable-ScheduledTask

Write-Host 'Scheduled Tasks : \Microsoft\Windows\Autochk\* : Disabled'
Get-ScheduledTask -TaskPath '\Microsoft\Windows\Autochk\' | Disable-ScheduledTask

Write-Host 'Scheduled Tasks : \Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector : Disabled'
Disable-ScheduledTask -TaskPath '\Microsoft\Windows\DiskDiagnostic\' -TaskName 'Microsoft-Windows-DiskDiagnosticDataCollector'

if ([System.Environment]::OSVersion.Version.Major -eq 10) {
    Write-Host 'System : Privacy : Data Collection : Disabled'
    $Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection'
    $null = (Test-Path -Path $Key -PathType Container) -or (New-Item -Path $Key -Force)
    $null = New-ItemProperty -Path $Key -Name AllowTelemetry -Value 0 -PropertyType DWord -Force
}

Write-Host 'Service : Diagnostics Tracking Service : Disabled'
Stop-Service -Name DiagTrack -Force -ErrorAction SilentlyContinue
Set-Service -Name DiagTrack -Status Stopped -StartupType Disabled -ErrorAction SilentlyContinue

$Key = 'HKLM:\SOFTWARE\Microsoft\SQMClient\Windows'
$null = New-ItemProperty -Path $Key -Name CEIPEnable -Value 0 -PropertyType DWord -Force
