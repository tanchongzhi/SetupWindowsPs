$ErrorActionPreference = 'Stop'

if ($PSVersionTable.PSVersion.Major -eq 2) {
    $PSScriptRoot = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
}

if (-not (Get-Command -Name Get-ScheduledTask -ErrorAction SilentlyContinue) -or
    -not (Get-Command -Name Disable-ScheduledTask -ErrorAction SilentlyContinue)) {
    Import-Module -Name "$PSScriptRoot\Modules\ScheduledTasks.psm1" -Force
}

$Key = 'HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance'
$null = (Test-Path -Path $Key -PathType Container) -or (New-Item -Path $Key)

Write-Host 'System : Remote Assistance : Disabled'
$null = New-ItemProperty -Path $Key -Name fAllowToGetHelp -Value 0 -PropertyType DWord -Force

Write-Host 'Scheduled Tasks : \Microsoft\Windows\RemoteAssistance\* : Disabled'
Get-ScheduledTask -TaskPath '\Microsoft\Windows\RemoteAssistance\' | Disable-ScheduledTask
