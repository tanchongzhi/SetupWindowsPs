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
        throw "The specified name already exists in the Shell SendTo submenu."
    }

    if (-not [string]::IsNullOrEmpty($Name)) {
        $Name = $Name.Trim()
    }

    $baseName = Split-Path -Path $TargetPath -Leaf

    if (Test-Path -Path $TargetPath -PathType Container) {
        if ([string]::IsNullOrEmpty($Name)) {
            if ([System.IO.Path]::GetPathRoot($TargetPath) -eq $TargetPath) {
                $InvalidFileNameChars = [System.IO.Path]::GetInvalidFileNameChars()
                $Name = ($Path.ToCharArray() | Where-Object -FilterScript { $InvalidFileNameChars -notcontains $_ }) -join ''
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

        if ($LinkTypes -contains $extension) {
            $destinationPath = $ShellSendToMenuPath

            if ($Name) {
                $destinationPath = Join-Path -Path $ShellSendToMenuPath -ChildPath $Name
            }

            null = Copy-Item -Path $TargetPath -Destination $destinationPath -Force
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
