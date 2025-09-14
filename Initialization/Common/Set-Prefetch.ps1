$ErrorActionPreference = 'Stop'

Write-Host 'Prefetch : Application launch and boot : Enabled'
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters' -Name EnablePrefetcher -Value 3 -Type DWord

if ([System.Environment]::OSVersion.Version.Major -eq 6) {
    Write-Host 'SuperPrefetch : Application launch and boot : Enabled'
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters' -Name EnableSuperfetch -Value 3 -Type DWord
}
