. "$PSScriptRoot\Internals\Common.ps1"
. "$PSScriptRoot\Internals\New-Shortcut.ps1"
. "$PSScriptRoot\Internals\Find-Shortcut.ps1"
. "$PSScriptRoot\Add-ShellSendToSubmenuItem.ps1"
. "$PSScriptRoot\Get-ShellSendToSubmenuItem.ps1"
. "$PSScriptRoot\Remove-ShellSendToSubmenuItem.ps1"


$ExportModuleMemberParameters = @{
    Function = @(
        'Add-ShellSendToSubmenuItem',
        'Get-ShellSendToSubmenuItem',
        'Remove-ShellSendToSubmenuItem'
    )
}

Export-ModuleMember @ExportModuleMemberParameters
