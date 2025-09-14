[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, ParameterSetName = 'Start')]
    [switch]
    $Start,

    [Parameter(Mandatory = $true, ParameterSetName = 'Stop')]
    [switch]
    $Stop
)

$ErrorActionPreference = 'Stop'

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    throw 'You must be running as an administrator, please restart as administrator'
}

$value = if ($Start) {
    1
} else {
    0
}

Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\services\LanmanServer\Parameters\' -Name AutoShareServer -Value $value -Type DWord
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\services\LanmanServer\Parameters\' -Name AutoShareWks -Value $value -Type DWord

Stop-Service -Name LanmanServer
Start-Service -Name LanmanServer
