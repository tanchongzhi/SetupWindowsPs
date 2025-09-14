#Requires -RunAsAdministrator

$ErrorActionPreference = 'Stop'

if ([System.Environment]::OSVersion.Version.Major -lt 10) {
    throw 'The operating system must be Windows 10 or later.'
}

bcdedit /set hypervisorlaunchtype auto
