function Remove-EnvironmentVariable {
    <#
    .SYNOPSIS
    Removes an environment variable.

    .OUTPUTS
    Returns a psobject if the name exists, otherwise, returns $null.

    The properties of the psobject:
        - Name
            The name of the environment variable.
        - Value
            The value of the environment variable.
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]
        $System,

        # Environment Variable Name.
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^[a-zA-Z_]\w*$')]
        [string]
        $Name
    )

    try {
        $environmentKey = Get-EnvironmentRegistryKey -System:$System

        $value = $environmentKey.GetValue($Name, $null, "DoNotExpandEnvironmentNames")

        if ($null -ne $value) {
            $environmentKey.DeleteValue($Name, $false)
            Send-EnvironmentChangeMessage
            New-Object -TypeName psobject -Property @{ Name = $Name; Value = $value }
        }
    } finally {
        if ($null -ne $environmentKey) {
            $environmentKey.Close()
        }
    }
}
