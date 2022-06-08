<#
.SYNOPSIS
Edit the Windows environment variables.
#>
[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $System,

    # Prints the path array in the Windows PATH environment variable.
    [Parameter(Mandatory = $true, ParameterSetName = "List")]
    [switch]
    $List,

    # Appends a path to the Windows PATH environment variable.
    [Parameter(Mandatory = $true, ParameterSetName = "Append")]
    [switch]
    $Append,

    # Inserts a path to the specified index in the Windows PATH environment variable.
    [Parameter(Mandatory = $true, ParameterSetName = "Insert")]
    [switch]
    $Insert,

    # Removes the specified path from the Windows PATH environment variable.
    [Parameter(Mandatory = $true, ParameterSetName = "RemoveByPath")]
    [Parameter(Mandatory = $true, ParameterSetName = "RemoveByIndex")]
    [switch]
    $Remove,

    [Parameter(Mandatory = $true, ParameterSetName = "Append", Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = "Insert", Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = "RemoveByPath", Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Path,

    [Parameter(Mandatory = $true, ParameterSetName = "Insert")]
    [Parameter(Mandatory = $true, ParameterSetName = "RemoveByIndex")]
    [ValidateScript( { $_ -ge 0 } )]
    [int]
    $Index
)

$ErrorActionPreference = "Stop"

if ($PSVersionTable.PSVersion.Major -eq 2) {
    $PSScriptRoot = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
}

$env:PSModulePath = "$PSScriptRoot\Core;$env:PSModulePath"

Import-Module -Name UpdateEnvironmentVariable -Force
Import-Module -Name UpdatePathEnvironmentVariable -Force

if ($List) {
    Get-PathEnvironmentVariableDirectory -System:$System |
        ForEach-Object -Begin { $i = 0 } -Process { New-Object -TypeName psobject -Property @{ Index = $i++; Path = $_ } } |
            Format-Table -Property Index, Path -Wrap -AutoSize

    exit 0
}

if ($Append) {
    $properties = @(
        @{ Label = "Append"; Expression = { $_.Path } },
        @{ Label = "OriginalPathValue"; Expression = { $_.Variable.OriginalValue } }
    )

    Add-PathEnvironmentVariableDirectory -System:$System -Path $Path -Index ([int]::MaxValue) |
        Format-List -Property $properties

    exit 0
}

if ($Insert) {
    $properties = @(
        @{ Label = "Insert"; Expression = { $_.Path } },
        @{ Label = "OriginalPathValue"; Expression = { $_.Variable.OriginalValue } }
    )

    Add-PathEnvironmentVariableDirectory -System:$System -Path $Path -Index $Index |
        Format-List -Property $properties

    exit 0
}

if ($Remove) {
    $properties = @(
        @{ Label = "Remove"; Expression = { $_.Path } },
        @{ Label = "OriginalPathValue"; Expression = { $_.Variable.OriginalValue } }
    )

    $removePathEnvironmentVariableDirectoryParameters = @{
        System = $System
    }

    if ([string]::IsNullOrEmpty($Path)) {
        $removePathEnvironmentVariableDirectoryParameters["Index"] = $Index
    } else {
        $removePathEnvironmentVariableDirectoryParameters["Path"] = $Path
    }

    Remove-PathEnvironmentVariableDirectory @removePathEnvironmentVariableDirectoryParameters |
        Format-List -Property $properties

    exit 0
}
