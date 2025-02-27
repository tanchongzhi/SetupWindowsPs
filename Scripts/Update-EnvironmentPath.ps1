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
    param (
        [Parameter()]
        [switch]
        $System
    )

    # You should call the Close() method of the key if you don't need it any more.
    if ($System) {
        [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey('SYSTEM\CurrentControlSet\Control\Session Manager\Environment', $true)
    } else {
        [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey('Environment', $true)
    }
}

function Get-PathEnvironmentVariableValue {
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
        Send-EnvironmentChangeMessage
    } finally {
        if ($null -ne $environmentKey) {
            $environmentKey.Close()
        }
    }
}

function Get-PathEnvironmentVariableDirectory {
    param (
        [Parameter()]
        [switch]
        $System
    )

    $value = Get-PathEnvironmentVariableValue -System:$System
    $value.Split(@([System.IO.Path]::PathSeparator), [System.StringSplitOptions]::RemoveEmptyEntries) |
        Where-Object -FilterScript { $_.Trim().Length -gt 0 }
}

function Add-PathEnvironmentVariableDirectory {
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
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $Path
    )

    $separators = @([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)

    $Path.TrimEnd($separators).Replace([System.IO.Path]::AltDirectorySeparatorChar, [System.IO.Path]::DirectorySeparatorChar)
}

function Remove-PathEnvironmentVariableDirectory {
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
        $finalDirectories = $directories | Where-Object -FilterScript { $normalizedPath -ine (NormalizePath -Path $_) }
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
        ForEach-Object -Begin { $i = 0 } -Process { New-Object -TypeName psobject -Property @{ Index = $i++; Path = $_ } } |
        Format-Table -Property Index, Path -Wrap -AutoSize

    exit 0
}

if ($Append) {
    Add-PathEnvironmentVariableDirectory -System:$System -Path $Path -Index ([int]::MaxValue)

    exit 0
}

if ($Insert) {
    Add-PathEnvironmentVariableDirectory -System:$System -Path $Path -Index $Index

    exit 0
}

if ($Remove) {
    $removePathEnvironmentVariableDirectoryParameters = @{
        System = $System
    }

    if ([string]::IsNullOrEmpty($Path)) {
        $removePathEnvironmentVariableDirectoryParameters['Index'] = $Index
    } else {
        $removePathEnvironmentVariableDirectoryParameters['Path'] = $Path
    }

    Remove-PathEnvironmentVariableDirectory @removePathEnvironmentVariableDirectoryParameters

    exit 0
}
