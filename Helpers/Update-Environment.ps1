<#
.SYNOPSIS
Edit the Windows environment variables.
#>
[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $System,

    # Prints all environment variables.
    [Parameter(Mandatory = $true, ParameterSetName = 'List')]
    [switch]
    $List,

    # Prints specified environment variable.
    [Parameter(Mandatory = $true, ParameterSetName = 'Get')]
    [switch]
    $Get,

    # Creates or overwrites an environment variable.
    [Parameter(Mandatory = $true, ParameterSetName = 'Set')]
    [switch]
    $Set,

    # Removes specified environment variable.
    [Parameter(Mandatory = $true, ParameterSetName = 'Remove')]
    [switch]
    $Remove,

    # Environment variable name.
    [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'Get')]
    [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'Set')]
    [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'Remove')]
    [ValidateNotNullOrEmpty()]
    [string]
    $Name,

    # Environment variable value.
    [Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'Set')]
    [ValidateLength(0, 32760)]
    [AllowEmptyString()]
    [string]
    $Value
)

$ErrorActionPreference = 'Stop'

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    throw 'You must be running as an administrator, please restart as administrator'
}

$NativeMethodsDefinition = @'
[DllImport("user32.dll", CharSet = CharSet.Unicode)]
public static extern int SendNotifyMessageW(IntPtr hWnd, uint Msg, IntPtr wParam, string lParam);
'@

if (-not ('MyInterop.Messaging' -as [type])) {
    Add-Type -Namespace MyInterop -Name Messaging -MemberDefinition $NativeMethodsDefinition
}

function Send-EnvironmentChangedMessage {
    $HWND_BROADCAST = [IntPtr]0xFFFF
    $WM_SETTINGCHANGE = 0x001A
    $null = [MyInterop.Messaging]::SendNotifyMessageW($HWND_BROADCAST, $WM_SETTINGCHANGE, [IntPtr]::Zero, 'Environment')
}

function Get-EnvironmentRegistryKey {
    <#
    .NOTES
    You should call the Close() method of the key if you don't need it any more.
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]
        $System
    )

    if ($System) {
        [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey('SYSTEM\CurrentControlSet\Control\Session Manager\Environment', $true)
    } else {
        [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey('Environment', $true)
    }
}

function Get-EnvironmentVariable {
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]
        $System,

        # Variable name. If the name is omitted, returns the all variables.
        [Parameter()]
        [ValidatePattern('^[a-zA-Z_]\w*$')]
        [string]
        $Name
    )

    $environmentKey = Get-EnvironmentRegistryKey -System:$System

    try {
        if ([string]::IsNullOrEmpty($Name)) {
            $environmentKey.GetValueNames() | ForEach-Object {
                $value = $environmentKey.GetValue($_, '', 'DoNotExpandEnvironmentNames')
                New-Object -TypeName psobject -Property @{ Name = $_; Value = $value }
            }
        } else {
            $value = $environmentKey.GetValue($Name, '', 'DoNotExpandEnvironmentNames')
            New-Object -TypeName psobject -Property @{ Name = $Name; Value = $value }
        }
    } finally {
        if ($null -ne $environmentKey) {
            $environmentKey.Close()
        }
    }
}

function Set-EnvironmentVariable {
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

    $environmentKey = Get-EnvironmentRegistryKey -System:$System

    if ($Value.Contains('%')) {
        $kind = 'ExpandString'
    } else {
        $kind = 'String'
    }

    try {
        $environmentKey.SetValue($Name, $Value, $kind)
    } finally {
        if ($null -ne $environmentKey) {
            $environmentKey.Close()
        }
    }

    Send-EnvironmentChangedMessage
}

function Remove-EnvironmentVariable {
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]
        $System,

        [Parameter(Mandatory = $true)]
        [ValidatePattern('^[a-zA-Z_]\w*$')]
        [string]
        $Name
    )

    $environmentKey = Get-EnvironmentRegistryKey -System:$System

    try {
        $environmentKey.DeleteValue($Name, $false)
        Send-EnvironmentChangedMessage
    } catch [System.ArgumentException] {
        # The Name does not exist.
    } finally {
        if ($null -ne $environmentKey) {
            $environmentKey.Close()
        }
    }
}

if ($List) {
    Get-EnvironmentVariable -System:$System |
        Format-Table -Property Name, Value -Wrap -AutoSize
} elseif ($Get) {
    Get-EnvironmentVariable -System:$System -Name $Name |
        Format-List -Property Name, Value
} elseif ($Set) {
    Set-EnvironmentVariable -System:$System -Name $Name -Value $Value
} elseif ($Remove) {
    Remove-EnvironmentVariable -System:$System -Name $Name
}
