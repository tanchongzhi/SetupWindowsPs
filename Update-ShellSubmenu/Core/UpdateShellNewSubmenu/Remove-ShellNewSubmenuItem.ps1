function Remove-ShellNewSubmenuItem {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^\.?[a-zA-Z0-9_-]+$')]
        [string]
        $FileType
    )

    $classes = Get-ShellNewSubmenuClasses

    if ($classes -notcontains $FileType) {
        return
    }

    $shellNewKey = "HKCR:\$FileType\ShellNew"

    if (Test-Path -Path $shellNewKey -PathType Container) {
        Remove-Item -Path $shellNewKey -Recurse -Force
        return
    }

    $progID = (Get-ItemProperty -Path "HKCR:\$FileType").'(default)'
    $searchList = @(
        "HKCR:\$FileType\$progID\ShellNew",
        "HKCR:\$progID\ShellNew"
    )

    foreach ($shellNewKey in $searchList) {
        if (Test-Path -Path $shellNewKey -PathType Container) {
            Remove-Item -Path $shellNewKey -Recurse -Force
            return
        }
    }
}
