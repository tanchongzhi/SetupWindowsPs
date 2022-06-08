function Get-PathEnvironmentVariableDirectory {
    <#
    .SYNOPSIS
    Returns a list of path strings.
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]
        $System
    )

    $variable = Get-EnvironmentVariable -System:$System -Name "PATH"
    $variable.Value.Split(@([System.IO.Path]::PathSeparator), [System.StringSplitOptions]::RemoveEmptyEntries) |
    Where-Object -FilterScript { $_.Trim().Length -gt 0 }
}
