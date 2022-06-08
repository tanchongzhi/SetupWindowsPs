function Get-EnvironmentVariable {
    <#
    .SYNOPSIS
    Get the specified variable or the all variables.

    .OUTPUTS
    One or more than one psobject.

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

        # Variable name. If the name is ommited, returns the all variables.
        [Parameter()]
        [ValidatePattern('^[a-zA-Z_]\w*$')]
        [string]
        $Name
    )

    try {
        $environmentKey = Get-EnvironmentRegistryKey -System:$System

        if ([string]::IsNullOrEmpty($Name)) {
            # Because of foreach loop will initialize the variable value to $null,
            # causes validation failure, so uses a different name.
            foreach ($name_ in $environmentKey.GetValueNames()) {
                $value = $environmentKey.GetValue($name_, "", "DoNotExpandEnvironmentNames")
                New-Object -TypeName psobject -Property @{ Name = $name_; Value = $value }
            }
        } else {
            $value = $environmentKey.GetValue($Name, "", "DoNotExpandEnvironmentNames")
            New-Object -TypeName psobject -Property @{ Name = $Name; Value = $value }
        }
    } finally {
        if ($null -ne $environmentKey) {
            $environmentKey.Close()
        }
    }
}
