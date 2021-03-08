<#
.SYNOPSIS
Edit the Shell New submenu.
#>

[CmdletBinding()]
param (
    # Prints all Shell New submenu items.
    [Parameter(Mandatory = $true, ParameterSetName = 'ListAvailable')]
    [switch]
    $ListAvailable,

    # Adds a file type to Shell New menu item by file extension.
    [Parameter(Mandatory = $true, ParameterSetName = 'Add')]
    [switch]
    $Add,

    # Deletes a Shell New menu item by file extension.
    [Parameter(Mandatory = $true, ParameterSetName = 'Delete')]
    [switch]
    $Delete,

    # File type.
    [Parameter(Mandatory = $true, ParameterSetName = 'Add', Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'Delete', Position = 0)]
    [ValidatePattern('^\.?[a-zA-Z0-9_-]+$')]
    [string]
    $FileType,

    # File creation methods:
    #     CopyFile
    #         Creates a file that is a copy of a specified file.
    #
    #         Inputs:
    #             -Value
    #                 The full path of the template file.
    #
    #     Command
    #         Executes a application.
    #
    #         Inputs:
    #             -Value
    #                 The path of the application to be executed.
    #
    #     WriteData
    #         Creates a file containing specified data.
    #
    #         Inputs:
    #             -Value
    #                 An UTF-8 String.
    #
    #     NullFile
    #         Creates an empty file.
    #
    [Parameter(ParameterSetName = 'Add', Position = 1)]
    [ValidateSet('CopyFile', 'Command', 'WriteData', 'NullFile')]
    [string]
    $FileCreationMethod = 'NullFile',

    # Specifies a value for the file creation method.
    # For example:
    #     Specifies a full file path for -FileCreationMethod CopyFile.
    [Parameter(ParameterSetName = 'Add', Position = 2)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Value,

    # Specifies a ProgID for the file type.
    # If the ProgID has already been set, this parameter will be ignored.
    [Parameter(ParameterSetName = 'Add')]
    [ValidatePattern('[a-zA-Z0-9_.-]{3,}')]
    [string]
    $ProgID,

    # Specifies a friendly name for the file type.
    # If the FriendlyName has already been set, this parameter will be ignored.
    [Parameter(ParameterSetName = 'Add')]
    [ValidateNotNullOrEmpty()]
    [string]
    $FriendlyName
)

$ErrorActionPreference = 'Stop'

if ($PSVersionTable.PSVersion.Major -eq 2) {
    $PSScriptRoot = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
}

$env:PSModulePath = "$PSScriptRoot\Core;$env:PSModulePath"

Import-Module -Name UpdateShellNewSubmenu -Force

if ($ListAvailable) {
    Get-ShellNewSubmenuItem | Format-Table -Wrap -AutoSize

    exit
}

if ($Add) {
    $AddShellNewSubmenuItemParameters = @{
        FileType = $FileType
        FileCreationMethod = $FileCreationMethod
    }
    if (-not [string]::IsNullOrEmpty($Value)) {
        $AddShellNewSubmenuItemParameters['Value'] = $Value
    }
    if (-not [string]::IsNullOrEmpty($ProgID)) {
        $AddShellNewSubmenuItemParameters['ProgID'] = $ProgID
    }
    if (-not [string]::IsNullOrEmpty($FriendlyName)) {
        $AddShellNewSubmenuItemParameters['FriendlyName'] = $FriendlyName
    }

    Add-ShellNewSubmenuItem @AddShellNewSubmenuItemParameters

    exit
}

if ($Delete) {
    Remove-ShellNewSubmenuItem -FileType $FileType

    exit
}
