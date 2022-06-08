function ProcessPathSlashes {
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $Path
    )

    $separators = @([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)

    $Path.TrimEnd($separators).Replace([System.IO.Path]::AltDirectorySeparatorChar, [System.IO.Path]::DirectorySeparatorChar)
}

function FilterPath {
    param (
        [Parameter(Mandatory = $true)]
        [string[]]
        $Path,

        [Parameter(Mandatory = $true)]
        [string]
        $Exclude
    )

    $Exclude = ProcessPathSlashes -Path $Exclude
    $Path | Where-Object -FilterScript { $Exclude -ne (ProcessPathSlashes -Path $_) }
}

function Remove-PathEnvironmentVariableDirectory {
    <#
    .SYNOPSIS
    Removes a path from the Windows PATH environment variable.

    .OUTPUTS
    A psobject.

    The properties of the psobject:
        - Variable
            - Name
                "PATH"
            - Value
                The value of the environment variable.
        - Path
            The path that has been removed.
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]
        $System,

        # The path to remove.
        [Parameter(Mandatory = $true, ParameterSetName = "Remove")]
        [ValidatePattern('^(?:[a-z]:[/\\]+|%\w+%)')]
        [string]
        $Path,

        # The zero-based index of the directory"s path to remove.
        [Parameter(Mandatory = $true, ParameterSetName = "RemoveAt")]
        [ValidateScript( { $_ -ge 0 } )]
        [int]
        $Index
    )

    $directories = Get-PathEnvironmentVariableDirectory -System:$System

    if (-not [string]::IsNullOrEmpty($Path)) {
        $finalDirectories = FilterPath -Path $directories -Exclude $Path
    } else {
        if ($Index -ge $directories.Length) {
            throw "-Index is out of range."
        }

        $finalDirectories = for ($i = 0; $i -lt $directories.Length; $i++) {
            if ($i -ne $Index) {
                $directories[$i]
            } else {
                $Path = $directories[$i]
            }
        }
    }

    $value = [string]::Join([System.IO.Path]::PathSeparator, $finalDirectories)
    $variable = Set-EnvironmentVariable -System:$System -Name "PATH" -Value $value
    New-Object -TypeName psobject -Property @{ Variable = $variable; Path = $Path; }
}
