. "$PSScriptRoot\Internals\Send-EnvironmentChangeMessage.ps1"
. "$PSScriptRoot\Internals\Get-EnvironmentRegistryKey.ps1"
. "$PSScriptRoot\Get-EnvironmentVariable.ps1"
. "$PSScriptRoot\Set-EnvironmentVariable.ps1"
. "$PSScriptRoot\Remove-EnvironmentVariable.ps1"


$ExportModuleMemberParameters = @{
    Function = @(
        "Get-EnvironmentVariable",
        "Set-EnvironmentVariable",
        "Remove-EnvironmentVariable"
    )
}

Export-ModuleMember @ExportModuleMemberParameters
