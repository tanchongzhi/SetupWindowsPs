<#
.SYNOPSIS
Edit Shell SendTo submenu.
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, ParameterSetName = 'ListAvailable')]
    [switch]
    $ListAvailable,

    [Parameter(Mandatory = $true, ParameterSetName = 'Add')]
    [switch]
    $Add,

    # Where to Send to. The specified path must be a directory, a shortcut,
    # or an executable file.
    [Parameter(Mandatory = $true, ParameterSetName = 'Add', Position = 0)]
    [ValidateScript( { Test-Path -Path $_ } )]
    [string]
    $TargetPath,

    [Parameter(Mandatory = $true, ParameterSetName = 'Remove')]
    [switch]
    $Remove,

    [Parameter(Mandatory = $true, ParameterSetName = 'Remove', Position = 0)]
    [Parameter(ParameterSetName = 'Add', Position = 1)]
    [ValidatePattern('^\S(.*\S)?$')]
    [string]
    $Name
)

$ErrorActionPreference = 'Stop'

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    throw 'You must be running as an administrator, please restart as administrator'
}

$LinkFileTypes = @('.lnk', '.DeskLink', '.mydocs', '.ZFSendToTarget', '.MAPIMail')
$ShellSendToMenuPath = "$env:APPDATA\Microsoft\Windows\SendTo"

function Find-Shortcut {
    [CmdletBinding()]
    param (
        # Shortcut file name
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        # Where the shortcut is stored
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path
    )

    try {
        $extension = [System.IO.Path]::GetExtension($Name)

        if ($LinkFileTypes -contains $extension) {
            $link = Join-Path -Path $Path -ChildPath $Name

            if (Test-Path -Path $link -PathType Leaf) {
                $link
            }

            return
        }
    } catch { }

    foreach ($extension in $LinkFileTypes) {
        $link = Join-Path -Path $Path -ChildPath ($Name + $extension)

        if (Test-Path -Path $link -PathType Leaf) {
            $link
        }
    }
}

function New-Shortcut {
    [CmdletBinding()]
    param (
        # The path of the created shortcut file.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path,

        # Where the shortcut point to.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $TargetPath
    )

    if (-not $Path.EndsWith('.lnk')) {
        $Path += '.lnk'
    }

    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($Path)
    $shortcut.TargetPath = $TargetPath
    $shortcut.Save()
}

function Get-ShellSendToSubmenuItem {
    $includes = $LinkFileTypes | ForEach-Object { '*' + $_ }
    Get-ChildItem -Path "$ShellSendToMenuPath\*" -Include $includes -Force
}

function Add-ShellSendToSubmenuItem {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript( { Test-Path -Path $_ } )]
        [string]
        $TargetPath,

        [Parameter()]
        [string]
        $Name
    )

    if ((-not [string]::IsNullOrEmpty($Name)) -and (Find-Shortcut -Name $Name -Path $ShellSendToMenuPath)) {
        throw 'The specified name already exists in the Shell SendTo submenu.'
    }

    if (-not [string]::IsNullOrEmpty($Name)) {
        $Name = $Name.Trim()
    }

    $baseName = Split-Path -Path $TargetPath -Leaf

    if (Test-Path -Path $TargetPath -PathType Container) {
        if ([string]::IsNullOrEmpty($Name)) {
            if ([System.IO.Path]::GetPathRoot($TargetPath) -eq $TargetPath) {
                $InvalidFileNameChars = [System.IO.Path]::GetInvalidFileNameChars()
                $Name = ($Path.ToCharArray() | Where-Object { $InvalidFileNameChars -notcontains $_ }) -join ''
            } else {
                $Name = $baseName
            }
        }
    } else {
        try {
            $extension = [System.IO.Path]::GetExtension($baseName)
        } catch {
            throw 'The specified path must be a directory, a shortcut, or an executable file.'
        }

        if ($LinkFileTypes -contains $extension) {
            $destinationPath = $ShellSendToMenuPath

            if ($Name) {
                $destinationPath = Join-Path -Path $ShellSendToMenuPath -ChildPath $Name
            }

            $null = Copy-Item -Path $TargetPath -Destination $destinationPath -Force
            exit
        } else {
            $executableExts = $env:PATHEXT.Split(';', [System.StringSplitOptions]::RemoveEmptyEntries)

            if ($executableExts -notcontains $extension) {
                throw 'The specified path must be a directory, a shortcut, or an executable file.'
            }

            if (-not $Name) {
                $Name = [System.IO.Path]::GetFileNameWithoutExtension($baseName) + '.lnk'
            }
        }
    }

    $link = Join-Path -Path $ShellSendToMenuPath -ChildPath $Name
    New-Shortcut -Path $link -TargetPath $TargetPath
}

function Remove-ShellSendToSubmenuItem {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name
    )

    $link = Find-Shortcut -Name $Name -Path $ShellSendToMenuPath

    if (-not $link) {
        return
    }

    if ($link.Count -ge 2) {
        throw 'Found multiple shortcuts have the same base name, please specify the full name of it.'
    }

    Remove-Item -Path $link -Force
}


if ($ListAvailable) {
    Get-ShellSendToSubmenuItem | ForEach-Object { $_.Name }
} elseif ($Add) {
    $PSBoundParameters.Remove('Add')

    Add-ShellSendToSubmenuItem @PSBoundParameters
} elseif ($Remove) {
    Remove-ShellSendToSubmenuItem -Name $Name
}
