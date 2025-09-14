#Requires -RunAsAdministrator

$ErrorActionPreference = 'Stop'

$osVersion = [System.Environment]::OSVersion.Version

if (($osVersion.Major -lt 10) -or ($osVersion.Build -lt 18362) -or (-not [System.Environment]::Is64BitOperatingSystem)) {
    throw 'The operating system must be Windows 10 (For x64 systems: Version 1903 or later, with Build 18362.1049 or later) or later.'
}

try {
    wsl --install --distribution Debian

    exit 0
} catch {
}

# https://docs.microsoft.com/en-us/windows/wsl/install-manual

if ((Get-WindowsOptionalFeature -FeatureName VirtualMachinePlatform -Online).State -eq 'Disabled') {
    Write-Host 'Enabling Windows feature: Virtual Machine Platform'
    Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All -NoRestart
}

if ((Get-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online).State -eq 'Disabled') {
    Write-Host 'Enabling Windows feature: Microsoft Windows Subsystem Linux'
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All -NoRestart
}

Write-Host 'Updating WSL 2 Linux kernel'

try {
    wsl --update
} catch {
    Invoke-WebRequest -Uri https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -OutFile $env:TEMP\wsl_update_x64.msi -UseBasicParsing
    msiexec $env:TEMP\wsl_update_x64.msi /quiet /norestart
}

Write-Host 'Setting up the default WSL version: 2'
wsl --set-default-version 2
