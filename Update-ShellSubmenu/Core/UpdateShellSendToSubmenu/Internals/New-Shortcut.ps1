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
