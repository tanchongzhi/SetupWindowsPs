$ErrorActionPreference = 'Stop'

if ($PSVersionTable.PSVersion.Major -eq 2) {
    $PSScriptRoot = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
}

if (-not (Get-Command -Name Get-ScheduledTask -ErrorAction SilentlyContinue) -or
    -not (Get-Command -Name Disable-ScheduledTask -ErrorAction SilentlyContinue)) {
    Import-Module -Name "$PSScriptRoot\Modules\ScheduledTasks.psm1" -Force
}

if ([System.Environment]::OSVersion.Version.Major -eq 6) {
    Import-Module -Name "$PSScriptRoot\Modules\SystemRestore.psm1" -Force

    Write-Host 'Windows Backup : Disabled'

    $drives = [System.IO.DriveInfo]::GetDrives() |
        Where-Object -FilterScript { $_.IsReady -and ($_.DriveType -eq 'Fixed') } |
        ForEach-Object -Process { $_.Name }

    Disable-ComputerRestore -Drive $drives

    Write-Host 'Windows Backup : Removing restore points...'
    Get-ComputerRestorePoint | Remove-ComputerRestorePoint 

    Write-Host 'Service: Windows Backup: Disabled'
    Set-Service -Name SDRSVC -Status Stopped -StartupType Disabled -ErrorAction SilentlyContinue

    Write-Host 'Scheduled Tasks : \Microsoft\Windows\WindowsBackup\ConfigNotification : Disabled'
    Get-ScheduledTask -TaskPath '\Microsoft\Windows\WindowsBackup\' -TaskName 'ConfigNotification' | Disable-ScheduledTask
}
