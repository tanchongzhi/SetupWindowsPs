function Set-EnvironmentVariable {
    <#
    .SYNOPSIS
    Creates or overwrites an environment variable.

    .OUTPUTS
    A psobject.

    The properties of the psobject:
        - Name
            The name of the environment variable.
        - OriginalValue
            The original value of the environment variable.
        - Value
            The current value of the environment variable.
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]
        $System,

        [Parameter(Mandatory = $true)]
        [ValidatePattern('^[a-zA-Z_]\w*$')]
        [string]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateLength(0, 32760)]
        [AllowEmptyString()]
        [string]
        $Value
    )

    try {
        $environmentKey = Get-EnvironmentRegistryKey -System:$System

        $originalValue = $environmentKey.GetValue($Name, "", "DoNotExpandEnvironmentNames")

        if ($Value.Contains("%")) {
            $kind = "ExpandString"
        } else {
            $kind = "String"
        }

        $environmentKey.SetValue($Name, $Value, $kind)
        Send-EnvironmentChangeMessage
        New-Object -TypeName psobject -Property @{ Name = $Name; Value = $Value; OriginalValue = $originalValue; }
    } finally {
        if ($null -ne $environmentKey) {
            $environmentKey.Close()
        }
    }
}
