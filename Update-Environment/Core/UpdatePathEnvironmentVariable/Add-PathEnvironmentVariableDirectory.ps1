function Add-PathEnvironmentVariableDirectory {
    <#
    .SYNOPSIS
    Adds a path to the Windows PATH environment variable.

    .OUTPUTS
    A psobject.

    The properties of the psobject:
        - Variable
            - Name
                "PATH"
            - OriginalValue
                The original value of the environment variable.
            - Value
                The current value of the environment variable.
        - Path
            The path that has been added.
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]
        $System,

        # The path to add.
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^(?:[a-z]:[/\\]+|%\w+%)')]
        [string]
        $Path,

        # The zero-based index at which path should be added.
        #
        # Defaults to add the path to the begining of the Windows PATH
        # environment variable.
        [Parameter()]
        [ValidateScript( { $_ -ge 0 } )]
        [int]
        $Index
    )

    $directories = Get-PathEnvironmentVariableDirectory -System:$System

    if ($Index -ge $directories.Length) {
        $finalDirectories = $directories + @($Path)
    } else {
        $finalDirectories = for ($i = 0; $i -lt $directories.Length; $i++) {
            if ($Index -eq $i) {
                $Path
            }
            $directories[$i]
        }
    }

    $value = [string]::Join([System.IO.Path]::PathSeparator, $finalDirectories)
    $variable = Set-EnvironmentVariable -System:$System -Name "PATH" -Value $value
    New-Object -TypeName psobject -Property @{ Variable = $variable; Path = $Path; }
}
