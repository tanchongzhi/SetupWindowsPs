param(
    [Parameter(Mandatory = $true, ParameterSetName = "Start")]
    [switch]
    $Start,

    [Parameter(Mandatory = $true, ParameterSetName = "Stop")]
    [switch]
    $Stop
)

$ErrorActionPreference = "Stop"

$Key = "HKLM:\System\CurrentControlSet\services\LanmanServer\Parameters\"

if ($Start) {
    $null = New-ItemProperty -Path $Key -Name AutoShareServer -Value 1 -PropertyType DWord -Force
    $null = New-ItemProperty -Path $Key -Name AutoShareWks -Value 1 -PropertyType DWord -Force
    Stop-Service -Name LanmanServer
    Start-Service -Name LanmanServer
}

if ($Stop) {
    $null = New-ItemProperty -Path $Key -Name AutoShareServer -Value 0 -PropertyType DWord -Force
    $null = New-ItemProperty -Path $Key -Name AutoShareWks -Value 0 -PropertyType DWord -Force
    Stop-Service -Name LanmanServer
    Start-Service -Name LanmanServer
}
