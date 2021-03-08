. "$PSScriptRoot\Internals\Common.ps1"
. "$PSScriptRoot\Internals\Get-ShellNewSubmenuClasses.ps1"
. "$PSScriptRoot\Add-ShellNewSubmenuItem.ps1"
. "$PSScriptRoot\Get-ShellNewSubmenuItem.ps1"
. "$PSScriptRoot\Remove-ShellNewSubmenuItem.ps1"


$ExportModuleMemberParameters = @{
    Function = @(
        'Add-ShellNewSubmenuItem',
        'Get-ShellNewSubmenuItem',
        'Remove-ShellNewSubmenuItem'
    )
}

Export-ModuleMember @ExportModuleMemberParameters
