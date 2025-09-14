#Requires -RunAsAdministrator

$ErrorActionPreference = 'Stop'

$osVersion = [System.Environment]::OSVersion.Version

if (($osVersion.Major -lt 10) -or ($osVersion.Build -lt 18362) -or (-not [System.Environment]::Is64BitOperatingSystem)) {
    throw 'The operating system must be Windows 10 (For x64 systems: Version 1903 or later, with Build 18362.1049 or later) or later.'
}

Write-Host 'Shuting down WSL running distributions...'
wsl --shutdown

Write-Host 'Unregistering installed distributions...'

$previousConsoleOutputEncoding = [Console]::OutputEncoding
[Console]::OutputEncoding = [System.Text.Encoding]::Unicode

$installedDistributions = wsl --list --verbose |
    Select-String -Pattern '^\s*\*?\s*([0-9A-Za-z._-]+)\s+.+$' |
    Select-String -Pattern '^\s*NAME\s+' -NotMatch |
    ForEach-Object { $_.Matches[0].Groups[1].Value }

[Console]::OutputEncoding = $previousConsoleOutputEncoding

$installedDistributions | ForEach-Object {
    try {
        wsl --unregister $_
    } catch {
    }
}

Write-Host 'Uninstalling distribution apps...'

$distributionInfoUrl = 'https://github.com/microsoft/WSL/raw/master/distributions/DistributionInfo.json'
$distributionInfoJsonContent = (Invoke-WebRequest -Uri $distributionInfoUrl -UseBasicParsing).Content
$distributionInfoData = $distributionInfoJsonContent | ConvertFrom-Json
$distributionInfoPackageFamilyNames = $distributionInfoData.Distributions | Select-Object -ExpandProperty PackageFamilyName -Unique

Get-AppxPackage | Where-Object { $distributionInfoPackageFamilyNames -contains $_.PackageFamilyName } | Remove-AppxPackage -ErrorAction Continue

Write-Host 'Uninstalling Windows Subsystem for Linux Update...'

if ($null -ne (Get-Package -Name 'Windows Subsystem for Linux Update*' -ProviderName msu -ErrorAction SilentlyContinue)) {
    try {
        wsl --update --rollback
    } catch {
    }
}

Get-Package -Name 'Windows Subsystem for Linux Update*' -ProviderName msi -ErrorAction SilentlyContinue |
    ForEach-Object { Uninstall-Package -Name $_.Name -ProviderName $_.ProviderName -Force -ErrorAction SilentlyContinue }

Write-Host 'Uninstalling WSL...'

try {
    wsl --uninstall
} catch {
}

Write-Host 'Disabling Windows feature: Microsoft Windows Subsystem Linux'
Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart

Write-Host 'Disabling Windows feature: Virtual Machine Platform'
Disable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
