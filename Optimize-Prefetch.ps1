if ([System.Environment]::OSVersion.Version.Major -eq 6) {
    $Key = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters'

    Write-Host 'System : Prefetch : Application launch and boot : Enabled'
    $null = New-ItemProperty -Path $Key -Name EnablePrefetcher -Value 3 -PropertyType DWord -Force

    Write-Host 'System : SuperPrefetch : Application launch and boot : Enabled'
    $null = New-ItemProperty -Path $Key -Name EnableSuperfetch -Value 3 -PropertyType DWord -Force
}
