function Get-ShellNewSubmenuClasses {
    <#
    .SYNOPSIS
    Get The all file types in Shell New submenu.
    #>
    [CmdletBinding()]
    [OutputType([string[]])]
    param ()

    $Key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Discardable\PostSetup\ShellNew"
    (Get-ItemProperty -Path $Key -Name Classes).Classes
}
