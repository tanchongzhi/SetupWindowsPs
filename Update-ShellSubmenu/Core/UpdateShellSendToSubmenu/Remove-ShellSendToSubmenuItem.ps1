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
