#Requires -Version 5.1
#Requires -RunAsAdministrator

[CmdletBinding(DefaultParameterSetName = 'DisableAll')]
param (
    [Parameter(ParameterSetName = 'DisableAll')]
    [switch]
    $Force,

    [Parameter(Mandatory = $true, ParameterSetName = 'ServerOnly')]
    [switch]
    $ServerOnly,

    [Parameter(Mandatory = $true, ParameterSetName = 'ClientOnly')]
    [switch]
    $ClientOnly
)

$ErrorActionPreference = 'Stop'

$osVersion = [System.Environment]::OSVersion.Version

if (($osVersion.Major -lt 10) -or ($osVersion.Build -lt 17763)) {
    throw 'The operating system must be at least Windows 10 (Version 1809).'
}

function Disable-OpenSSHServer {
    param ()

    Write-Host 'Disabling Windows feature: OpenSSH Server'
    Get-WindowsCapability -Online | Where-Object { ($_.Name -like 'OpenSSH.Server*') -and ($_.State -eq 'Installed') } | Remove-WindowsCapability -Online
}

function Disable-OpenSSHClient {
    param ()

    Write-Host 'Disabling Windows feature: OpenSSH Client'
    Get-WindowsCapability -Online | Where-Object { ($_.Name -like 'OpenSSH.Client*') -and ($_.State -eq 'Installed') } | Remove-WindowsCapability -Online
}

if ($ServerOnly) {
    Disable-OpenSSHServer
} elseif ($ClientOnly) {
    Disable-OpenSSHClient
} else {
    if (-not $Force) {
        $title = 'Disable OpenSSH Client and Server'
        $question = 'Are you sure you want to perform this action?'
        $choices = ('&Yes', '&No')

        $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)

        if ($decision -ne 0) {
            return
        }
    }

    Disable-OpenSSHServer
    Disable-OpenSSHClient
}

Write-Warning 'The OpenSSH configuration files, registry keys, and firewall rules need to be deleted manually.'
