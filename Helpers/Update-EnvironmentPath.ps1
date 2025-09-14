<#
.SYNOPSIS
Edit the Windows environment variables.
#>
[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $System,

    [Parameter(Mandatory = $true, ParameterSetName = 'List')]
    [switch]
    $List,

    [Parameter(Mandatory = $true, ParameterSetName = 'Append')]
    [switch]
    $Append,

    [Parameter(Mandatory = $true, ParameterSetName = 'Insert')]
    [switch]
    $Insert,

    [Parameter(Mandatory = $true, ParameterSetName = 'RemoveByPath')]
    [Parameter(Mandatory = $true, ParameterSetName = 'RemoveByIndex')]
    [switch]
    $Remove,

    [Parameter(Mandatory = $true, ParameterSetName = 'Append', Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'Insert', Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'RemoveByPath', Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Path,

    [Parameter(Mandatory = $true, ParameterSetName = 'Insert')]
    [Parameter(Mandatory = $true, ParameterSetName = 'RemoveByIndex')]
    [ValidateScript( { $_ -ge 0 } )]
    [int]
    $Index
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

function Get-PathEnvironmentVariableValue {
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]
        $System
    )

    $environmentKey = Get-EnvironmentRegistryKey -System:$System

    try {
        $environmentKey.GetValue('Path', '', 'DoNotExpandEnvironmentNames')
    } finally {
        if ($null -ne $environmentKey) {
            $environmentKey.Close()
        }
    }
}

function Set-PathEnvironmentVariableValue {
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]
        $System,

        [Parameter(Mandatory = $true)]
        [string]
        $Value
    )

    $environmentKey = Get-EnvironmentRegistryKey -System:$System

    try {
        $environmentKey.SetValue('Path', $Value, 'ExpandString')
    } finally {
        if ($null -ne $environmentKey) {
            $environmentKey.Close()
        }
    }

    Send-EnvironmentChangedMessage
}

function Get-PathEnvironmentVariableDirectory {
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]
        $System
    )

    $value = Get-PathEnvironmentVariableValue -System:$System
    $value.Split(@([System.IO.Path]::PathSeparator), [System.StringSplitOptions]::RemoveEmptyEntries) |
        Where-Object { $_.Trim().Length -gt 0 }
}

function Add-PathEnvironmentVariableDirectory {
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]
        $System,

        [Parameter(Mandatory = $true)]
        [ValidatePattern('^(?:[a-z]:[/\\]+|%\w+%)')]
        [string]
        $Path,

        [Parameter()]
        [ValidateScript( { $_ -ge 0 } )]
        [int]
        $Index
    )

    $directories = Get-PathEnvironmentVariableDirectory -System:$System

    if ($Index -ge $directories.Length) {
        $finalDirectories = $directories + @($Path)
    } else {
        $finalDirectories = for ($i = 0; $i -lt $directories.Length; $i++) {
            if ($Index -eq $i) {
                $Path
            }

            $directories[$i]
        }
    }

    $value = [string]::Join([System.IO.Path]::PathSeparator, $finalDirectories)
    Set-PathEnvironmentVariableValue -System:$System -Value $value
}

function NormalizePath {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $Path
    )

    $separators = @([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)

    $Path.TrimEnd($separators).Replace([System.IO.Path]::AltDirectorySeparatorChar, [System.IO.Path]::DirectorySeparatorChar)
}

function Remove-PathEnvironmentVariableDirectory {
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]
        $System,

        [Parameter(Mandatory = $true, ParameterSetName = 'RemoveByPath')]
        [ValidatePattern('^(?:[a-z]:[/\\]+|%\w+%)')]
        [string]
        $Path,

        [Parameter(Mandatory = $true, ParameterSetName = 'RemoveByIndex')]
        [ValidateScript( { $_ -ge 0 } )]
        [int]
        $Index
    )

    $directories = Get-PathEnvironmentVariableDirectory -System:$System

    if (-not [string]::IsNullOrEmpty($Path)) {
        $normalizedPath = NormalizePath -Path $Path
        $finalDirectories = $directories | Where-Object { $normalizedPath -ine (NormalizePath -Path $_) }
    } else {
        if ($Index -ge $directories.Length) {
            throw '-Index is out of range.'
        }

        $finalDirectories = for ($i = 0; $i -lt $directories.Length; $i++) {
            if ($i -ne $Index) {
                $directories[$i]
            }
        }
    }

    $value = [string]::Join([System.IO.Path]::PathSeparator, $finalDirectories)
    Set-PathEnvironmentVariableValue -System:$System -Value $value
}

if ($List) {
    Get-PathEnvironmentVariableDirectory -System:$System |
        ForEach-Object -Begin { $index = 0 } -Process { New-Object -TypeName psobject -Property @{ Index = $index++; Path = $_ } } |
        Format-Table -Property Index, Path -Wrap -AutoSize
} elseif ($Append) {
    Add-PathEnvironmentVariableDirectory -System:$System -Path $Path -Index ([int]::MaxValue)
} elseif ($Insert) {
    Add-PathEnvironmentVariableDirectory -System:$System -Path $Path -Index $Index
} elseif ($Remove) {
    $PSBoundParameters.Remove('Remove') | Out-Null

    Remove-PathEnvironmentVariableDirectory @PSBoundParameters
}
