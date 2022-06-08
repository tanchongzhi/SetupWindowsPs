function Get-ShellSendToSubmenuItem {
    [CmdletBinding()]
    param ()

    $includes = $LinkTypes | ForEach-Object -Process { "*" + $_ }
    Get-ChildItem -Path "$ShellSendToMenuPath\*" -Include $includes -Force
}
