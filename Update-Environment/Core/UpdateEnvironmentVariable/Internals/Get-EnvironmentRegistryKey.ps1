function Get-EnvironmentRegistryKey {
    <#
    .SYNOPSIS
    Get the writable registry key of the Windows Environment of the
    current user or system.

    .NOTES
    You should call the Close() method of the key if you don"t need it any more.
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]
        $System
    )

    if ($System) {
        [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("SYSTEM\CurrentControlSet\Control\Session Manager\Environment", $true)
    } else {
        [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey("Environment", $true)
    }
}
