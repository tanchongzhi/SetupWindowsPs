$ErrorActionPreference = 'Stop'

if ($PSVersionTable.PSVersion.Major -eq 2) {
    $PSScriptRoot = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
}

if (-not (Get-Command -Name Get-ScheduledTask -ErrorAction SilentlyContinue) -or
    -not (Get-Command -Name Disable-ScheduledTask -ErrorAction SilentlyContinue)) {
    Import-Module -Name "$PSScriptRoot\Modules\ScheduledTasks.psm1" -Force
}

Write-Host 'Remote Assistance : Disabled'
$Key = 'HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name fAllowToGetHelp -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Scheduled Tasks : \Microsoft\Windows\RemoteAssistance\* : Disabled'
Get-ScheduledTask -TaskPath '\Microsoft\Windows\RemoteAssistance\' | Disable-ScheduledTask
