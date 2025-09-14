[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $IncludeOptionalSettings
)

$ErrorActionPreference = 'Stop'

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    throw 'You must be running as an administrator, please restart as administrator'
}

if ($PSVersiontable.PSVersion.Major -le 2) {
    $PSScriptRoot = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
}

$osVersion = [System.Environment]::OSVersion.Version

$scriptSources = @(
    "$PSScriptRoot\Common"
)

if ($osVersion.Major -eq 6) {
    $scriptSources += "$PSScriptRoot\Windows7"
}

if ($osVersion.Major -ge 10) {
    $scriptSources += "$PSScriptRoot\Windows10"
}

$optionalScripts = @(
    (Join-Path -Path $PSScriptRoot -ChildPath 'Common\Disable-ShutdownWithoutLogon.ps1'),
    (Join-Path -Path $PSScriptRoot -ChildPath 'Common\Disable-WindowsBackup.ps1')
)

Get-ChildItem -Path $scriptSources -Filter '*.ps1' -Recurse | ForEach-Object {
    if (($optionalScripts -icontains $_.FullName) -and -not $IncludeOptionalSettings) {
        return
    }

    $name = $_.FullName.Substring($PSScriptRoot.Length + 1)

    Write-Host
    Write-Host "Executing $name"

    & $_.FullName
}

if (-not $IncludeOptionalSettings) {
    Write-Host
    Write-Host 'The following optional scripts was not executed:'

    $optionalScripts | ForEach-Object { Write-Host ($_.Substring($PSScriptRoot.Length + 1)) }
}
