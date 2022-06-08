function Find-Shortcut {
    [CmdletBinding()]
    [OutputType([string[]])]
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

        if ($LinkTypes -contains $extension) {
            $link = Join-Path -Path $Path -ChildPath $Name

            if (Test-Path -Path $link -PathType Leaf) {
                $link
            }

            return
        }
    } catch { }

    foreach ($extension in $LinkTypes) {
        $link = Join-Path -Path $Path -ChildPath ($Name + $extension)

        if (Test-Path -Path $link -PathType Leaf) {
            $link
        }
    }
}
