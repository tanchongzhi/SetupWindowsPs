param(
    [Parameter(Mandatory = $true, ParameterSetName = 'Start')]
    [switch]
    $Start,

    [Parameter(Mandatory = $true, ParameterSetName = 'Stop')]
    [switch]
    $Stop
)

$ErrorActionPreference = 'Stop'

$Key = 'HKLM:\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters\'

if ($Start) {
    New-ItemProperty -Path $Key -Name AutoShareServer -Value 1 -PropertyType DWord -Force | Out-Null
    New-ItemProperty -Path $Key -Name AutoShareWks -Value 1 -PropertyType DWord -Force | Out-Null
    Stop-Service -Name LanmanServer
    Start-Service -Name LanmanServer
}

if ($Stop) {
    New-ItemProperty -Path $Key -Name AutoShareServer -Value 0 -PropertyType DWord -Force | Out-Null
    New-ItemProperty -Path $Key -Name AutoShareWks -Value 0 -PropertyType DWord -Force | Out-Null
    Stop-Service -Name LanmanServer
    Start-Service -Name LanmanServer
}
