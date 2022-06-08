function Get-ShellNewSubmenuItem {
    <#
    .SYNOPSIS
    Get Shell New submenu items infomation.

    .OUTPUTS
    A psobject array.

    The properties of the psobject:
        FileType
        FriendlyName
    #>
    [CmdletBinding()]
    param ()

    foreach ($fileType in (Get-ShellNewSubmenuClasses)) {
        $progID = (Get-ItemProperty -Path "HKCR:\$fileType")."(default)"
        $friendlyName = (Get-ItemProperty -Path "HKCR:\$progID")."(default)"

        if ($ShellNewSubmenuPreservedFileTypes -notcontains $fileType) {
            New-Object -TypeName psobject -Property @{ FileType = $fileType; FriendlyName = $friendlyName; }
        }
    }
}
