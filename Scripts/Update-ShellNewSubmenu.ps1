<#
.SYNOPSIS
Edit the Shell New submenu.
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, ParameterSetName = 'ListAvailable')]
    [switch]
    $ListAvailable,

    [Parameter(Mandatory = $true, ParameterSetName = 'Add')]
    [switch]
    $Add,

    [Parameter(Mandatory = $true, ParameterSetName = 'Remove')]
    [switch]
    $Remove,

    [Parameter(Mandatory = $true, ParameterSetName = 'Add', Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'Remove', Position = 0)]
    [ValidatePattern('^\.?[a-zA-Z0-9_-]+$')]
    [string]
    $FileType,

    [Parameter(ParameterSetName = 'Add', Position = 1)]
    [ValidateSet('CopyFile', 'Command', 'WriteData', 'NullFile')]
    [string]
    $FileCreationMethod = 'NullFile',

    # Specify a value for the file creation method.
    # For example, specify a full file path for "CopyFile".
    [Parameter(ParameterSetName = 'Add', Position = 2)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Value,

    # Specify a ProgID for the file type.
    # If the ProgID has already been set, this parameter will be ignored.
    [Parameter(ParameterSetName = 'Add')]
    [ValidatePattern('[a-zA-Z0-9_.-]{3,}')]
    [string]
    $ProgrammaticID,

    # Specify a friendly name for the file type.
    # If the FriendlyName has already been set, this parameter will be ignored.
    [Parameter(ParameterSetName = 'Add')]
    [ValidateNotNullOrEmpty()]
    [string]
    $FriendlyName
)

$ErrorActionPreference = 'Stop'

New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null

$ShellNewSubmenuPreservedFileTypes = @('.lnk', '.library-ms', 'Folder')

function Get-ShellNewSubmenuFileTypes {
    $Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Discardable\PostSetup\ShellNew'
    (Get-ItemProperty -Path $Key -Name Classes).Classes
}

function Get-ShellNewSubmenuItem {
    foreach ($fileType in (Get-ShellNewSubmenuFileTypes)) {
        $progID = (Get-ItemProperty -Path "HKCR:\$fileType").'(default)'
        $friendlyName = (Get-ItemProperty -Path "HKCR:\$progID").'(default)'

        if ($ShellNewSubmenuPreservedFileTypes -notcontains $fileType) {
            New-Object -TypeName psobject -Property @{ FileType = $fileType; FriendlyName = $friendlyName; }
        }
    }
}

function Add-ShellNewSubmenuItem {
    param (
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^\.?[a-zA-Z0-9_-]+$')]
        [string]
        $FileType,

        [Parameter()]
        [ValidateSet('CopyFile', 'Command', 'WriteData', 'NullFile')]
        [string]
        $FileCreationMethod = 'NullFile',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Value,

        [Parameter()]
        [ValidatePattern('[a-zA-Z0-9_.-]{3,}')]
        [string]
        $ProgrammaticID,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $FriendlyName
    )

    if ($ShellNewSubmenuPreservedFileTypes -contains $FileType) {
        throw "Unable to edit the preserved file type '$FileType'."
    }

    if (($FileCreationMethod -ne 'NullFile') -and [string]::IsNullOrEmpty($Value)) {
        throw "When -FileCreationMethod is '$FileCreationMethod', the parameter -Value is required."
    }

    if (Test-Path -Path "HKCR:\$FileType") {
        $currentProgID = (Get-ItemProperty -Path "HKCR:\$FileType").'(default)'

        if ([string]::IsNullOrEmpty($currentProgID)) {
            if ([string]::IsNullOrEmpty($ProgrammaticID)) {
                throw 'The specified file type has no ProgID, the parameter -ProgrammaticID is required.'
            }

            Set-Item -Path "HKCR:\$FileType" -Value $ProgrammaticID -Force | Out-Null
        } else {
            if (-not [string]::IsNullOrEmpty($ProgrammaticID)) {
                Write-Host "Warning: The ProgID of the specified file type '$FileType' has already been set to '$currentProgID'. "
                Write-Host 'Warning: The specified parameter -ProgrammaticID will be ignored.'
            }

            $ProgrammaticID = $currentProgID
        }
    } else {
        if ([string]::IsNullOrEmpty($ProgrammaticID)) {
            throw 'The specified file type has no ProgID, the parameter -ProgrammaticID is required.'
        }

        New-Item -Path "HKCR:\$FileType" -Value $ProgrammaticID -Force | Out-Null
    }

    if (Test-Path -Path "HKCR:\$ProgrammaticID") {
        $currentFriendlyName = (Get-ItemProperty -Path "HKCR:\$ProgrammaticID").'(default)'

        if ([string]::IsNullOrEmpty($currentFriendlyName)) {
            if ([string]::IsNullOrEmpty($FriendlyName)) {
                throw 'The specified file type has no friendly name, the parameter -FriendlyName is required.'
            }

            Set-Item -Path "HKCR:\$ProgrammaticID" -Value $FriendlyName -Force | Out-Null
        } else {
            if (-not [string]::IsNullOrEmpty($FriendlyName)) {
                Write-Host "Warning: The friendly name of the specified file type '$FileType' has already set to '$currentFriendlyName'."
                Write-Host 'Warning: The specified parameter -FriendlyName will be ignored.'
            }
        }
    } else {
        if ([string]::IsNullOrEmpty($FriendlyName)) {
            throw 'The specified file type has no friendly name, the parameter -FriendlyName is required.'
        }

        New-Item -Path "HKCR:\$ProgrammaticID" -Value $FriendlyName -Force | Out-Null
    }

    $shellNewParentKey = if (Test-Path -Path "HKCR:\$FileType\$ProgrammaticID") {
        "HKCR:\$FileType\$ProgrammaticID"
    } else {
        "HKCR:\$FileType"
    }

    $shellNewKey = "$shellNewParentKey\ShellNew"

    if (Test-Path -Path $shellNewKey) {
        $conflictingMethods = @('NullFile', 'FileName', 'Data', 'Command') | Where-Object -FilterScript { Get-ItemProperty -Path $shellNewKey -Name $_ -ErrorAction SilentlyContinue }

        if ($conflictingMethods) {
            throw "The specified file type has already been added to Shell New submenu with file creation method: '$($conflictingMethods[0])'."
        }
    } else {
        New-Item -Path $shellNewKey -Force | Out-Null
    }

    switch ($FileCreationMethod) {
        'NullFile' {
            New-ItemProperty -Path $shellNewKey -Name NullFile -PropertyType String -Force | Out-Null
            break
        }
        'CopyFile' {
            $item = Get-Item -Path $Value -Force
            New-ItemProperty -Path $shellNewKey -Name FileName -Value $item.FullName -PropertyType String -Force | Out-Null
            break
        }
        'WriteData' {
            $dataBytes = [System.Text.Encoding]::UTF8.GetBytes($Value)
            New-ItemProperty -Path $shellNewKey -Name Data -Value $dataBytes -PropertyType Binary -Force | Out-Null
            break
        }
        'Command' {
            New-ItemProperty -Path $shellNewKey -Name Command -Value $Value -PropertyType String -Force | Out-Null
            break
        }
        default {
            break
        }
    }
}

function Remove-ShellNewSubmenuItem {
    param (
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^\.?[a-zA-Z0-9_-]+$')]
        [string]
        $FileType
    )

    $fileTypes = Get-ShellNewSubmenuFileTypes

    if ($fileTypes -notcontains $FileType) {
        return
    }

    $progID = (Get-ItemProperty -Path "HKCR:\$FileType").'(default)'
    $searchList = @(
        "HKCR:\$FileType\ShellNew",
        "HKCR:\$FileType\$progID\ShellNew"
    )

    $searchList | ForEach-Object {
        if (Test-Path -Path $_) {
            Remove-Item -Path $_ -Recurse -Force
        }
    }
}

if ($ListAvailable) {
    Get-ShellNewSubmenuItem | Format-Table -Wrap -AutoSize

    exit 0
}

if ($Add) {
    $AddShellNewSubmenuItemParameters = @{
        FileType           = $FileType
        FileCreationMethod = $FileCreationMethod
    }

    if (-not [string]::IsNullOrEmpty($Value)) {
        $AddShellNewSubmenuItemParameters['Value'] = $Value
    }

    if (-not [string]::IsNullOrEmpty($ProgrammaticID)) {
        $AddShellNewSubmenuItemParameters['ProgrammaticID'] = $ProgrammaticID
    }

    if (-not [string]::IsNullOrEmpty($FriendlyName)) {
        $AddShellNewSubmenuItemParameters['FriendlyName'] = $FriendlyName
    }

    Add-ShellNewSubmenuItem @AddShellNewSubmenuItemParameters

    exit 0
}

if ($Remove) {
    Remove-ShellNewSubmenuItem -FileType $FileType

    exit 0
}
