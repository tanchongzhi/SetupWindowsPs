$ErrorActionPreference = 'Stop'

if ([System.Environment]::OSVersion.Version.Major -eq 6) {
    $Key = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters\'

    Write-Host 'Prefetch : Application launch and boot : Enabled'
    New-ItemProperty -Path $Key -Name EnablePrefetcher -Value 3 -PropertyType DWord -Force | Out-Null

    Write-Host 'SuperPrefetch : Application launch and boot : Enabled'
    New-ItemProperty -Path $Key -Name EnableSuperfetch -Value 3 -PropertyType DWord -Force | Out-Null
}
