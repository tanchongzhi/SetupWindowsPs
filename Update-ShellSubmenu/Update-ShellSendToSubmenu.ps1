<#
.SYNOPSIS
Edit Shell SendTo submenu.
#>
[CmdletBinding()]
param (
    # Prints all Shell SendTo submenu items.
    [Parameter(Mandatory = $true, ParameterSetName = 'ListAvailable')]
    [switch]
    $ListAvailable,

    # Adds the specified path to Shell SendTo submenu.
    [Parameter(Mandatory = $true, ParameterSetName = 'Add')]
    [switch]
    $Add,

    # Where to Send to. The specified path must be a directory, a shortcut,
    # or an executable file.
    [Parameter(Mandatory = $true, ParameterSetName = 'Add', Position = 0)]
    [ValidateScript( { Test-Path -Path $_ } )]
    [string]
    $TargetPath,

    # Deletes a item from Shell SendTo submenu with the specified name.
    [Parameter(Mandatory = $true, ParameterSetName = 'Delete')]
    [switch]
    $Delete,

    # Shortcut name.
    [Parameter(Mandatory = $true, ParameterSetName = 'Delete', Position = 0)]
    [Parameter(ParameterSetName = 'Add', Position = 1)]
    [ValidatePattern('\S+')]
    [string]
    $Name
)

$ErrorActionPreference = 'Stop'

if ($PSVersionTable.PSVersion.Major -eq 2) {
    $PSScriptRoot = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
}

$env:PSModulePath = "$PSScriptRoot\Core;$env:PSModulePath"

Import-Module -Name UpdateShellSendToSubmenu -Force

if ($ListAvailable) {
    Get-ShellSendToSubmenuItem | ForEach-Object -Process { $_.Name }

    exit
}

if ($Add) {
    $AddShellSendToSubmenuItemParameters = @{
        TargetPath = $TargetPath
    }
    if (-not [string]::IsNullOrEmpty($Name)) {
        $AddShellSendToSubmenuItemParameters['Name'] = $Name
    }
    Add-ShellSendToSubmenuItem @AddShellSendToSubmenuItemParameters

    exit
}

if ($Delete) {
    Remove-ShellSendToSubmenuItem -Name $Name

    exit
}
