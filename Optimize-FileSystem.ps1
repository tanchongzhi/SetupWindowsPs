Write-Host 'System : FileSystem : NTFS increases the size of its lookaside lists and memory thresholds: Enabled'
fsutil behavior set MemoryUsage 2 >$null 2>&1

if ([System.Environment]::OSVersion.Version.Major -eq 10) {
    $Key = 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem'

    Write-Host 'System : FileSystem : NTFS long path support : Enabled'
    $null = New-ItemProperty -Path $Key -Name LongPathsEnabled -Value 1 -PropertyType DWord -Force
}
