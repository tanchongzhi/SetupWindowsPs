<#
.SYNOPSIS
Edit the Windows environment variables.
#>
[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $System,

    # Prints all environment variables.
    [Parameter(Mandatory = $true, ParameterSetName = "List")]
    [switch]
    $List,

    # Prints specified environment variable.
    [Parameter(Mandatory = $true, ParameterSetName = "Get")]
    [switch]
    $Get,

    # Creates or overwrites an environment variable.
    [Parameter(Mandatory = $true, ParameterSetName = "Set")]
    [switch]
    $Set,

    # Removes specified environment variable.
    [Parameter(Mandatory = $true, ParameterSetName = "Remove")]
    [switch]
    $Remove,

    # Environment variable name.
    [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "Get")]
    [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "Set")]
    [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "Remove")]
    [ValidateNotNullOrEmpty()]
    [string]
    $Name,

    # Environment variable value.
    [Parameter(Mandatory = $true, Position = 1, ParameterSetName = "Set")]
    [ValidateLength(0, 32760)]
    [AllowEmptyString()]
    [string]
    $Value
)

$ErrorActionPreference = "Stop"

if ($PSVersionTable.PSVersion.Major -eq 2) {
    $PSScriptRoot = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
}

$env:PSModulePath = "$PSScriptRoot\Core;$env:PSModulePath"

Import-Module -Name UpdateEnvironmentVariable -Force
Import-Module -Name UpdatePathEnvironmentVariable -Force

if ($List) {
    Get-EnvironmentVariable -System:$System |
        Format-Table -Property @{ Label = "Variable"; Expression = "Name" }, Value -Wrap -AutoSize

    exit 0
}

if ($Get) {
    Get-EnvironmentVariable -System:$System -Name $Name |
        Format-List -Property Name, Value

    exit 0
}

if ($Set) {
    Set-EnvironmentVariable -System:$System -Name $Name -Value $Value |
        Format-List -Property Name, Value, OriginalValue

    exit 0
}

if ($Remove) {
    Remove-EnvironmentVariable -System:$System -Name $Name |
        Format-List -Property Name, Value

    exit 0
}
