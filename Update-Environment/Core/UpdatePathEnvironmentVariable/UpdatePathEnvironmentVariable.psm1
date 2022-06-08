Import-Module -Name UpdateEnvironmentVariable -ErrorAction Stop

. "$PSScriptRoot\Get-PathEnvironmentVariableDirectory.ps1"
. "$PSScriptRoot\Add-PathEnvironmentVariableDirectory.ps1"
. "$PSScriptRoot\Remove-PathEnvironmentVariableDirectory.ps1"

$ExportModuleMemberParameters = @{
    Function = @(
        "Get-PathEnvironmentVariableDirectory",
        "Add-PathEnvironmentVariableDirectory",
        "Remove-PathEnvironmentVariableDirectory"
    )
}

Export-ModuleMember @ExportModuleMemberParameters
