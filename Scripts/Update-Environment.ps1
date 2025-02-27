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

$_User32APINativeMethodSignatures = @'
    [DllImport("User32.dll", EntryPoint = "SendMessageTimeoutW", SetLastError = true, CharSet = CharSet.Unicode)]
    public static extern IntPtr SendMessageTimeout(IntPtr hWnd, int msg, IntPtr wParam, string lParam, int flags, int timeout, IntPtr pdwResult);
'@

function Send-EnvironmentChangeMessage {
    begin {
        if (-not ('NativeMethods.User32API' -as [type])) {
            $AddTypeParameters = @{
                MemberDefinition = $_User32APINativeMethodSignatures
                Name             = 'User32API'
                NameSpace        = 'NativeMethods'
            }
            Add-Type @AddTypeParameters
        }
    }

    process {
        $HWND_BROADCAST = [IntPtr]0xFFFF
        $WM_WININICHANGE = 0x001A
        $WM_SETTINGCHANGE = $WM_WININICHANGE
        $SMTO_ABORTIFHUNG = 0x002

        $DefaultTimeout = 300  # in milliseconds.
        [NativeMethods.User32API]::SendMessageTimeout($HWND_BROADCAST, $WM_SETTINGCHANGE, [IntPtr]::Zero, 'Environment', $SMTO_ABORTIFHUNG, $DefaultTimeout, [IntPtr]::Zero) | Out-Null
    }
}

function Get-EnvironmentRegistryKey {
    <#
    .NOTES
    You should call the Close() method of the key if you don"t need it any more.
    #>
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
        Send-EnvironmentChangeMessage
    } finally {
        if ($null -ne $environmentKey) {
            $environmentKey.Close()
        }
    }
}

function Remove-EnvironmentVariable {
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
        Send-EnvironmentChangeMessage
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

    exit 0
}

if ($Get) {
    Get-EnvironmentVariable -System:$System -Name $Name |
        Format-List -Property Name, Value

    exit 0
}

if ($Set) {
    Set-EnvironmentVariable -System:$System -Name $Name -Value $Value

    exit 0
}

if ($Remove) {
    Remove-EnvironmentVariable -System:$System -Name $Name

    exit 0
}
