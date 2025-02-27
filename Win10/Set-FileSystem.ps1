$ErrorActionPreference = 'Stop'

$Key = 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem\'

Write-Host 'FileSystem : Long Paths Support : Enabled'
New-ItemProperty -Path $Key -Name LongPathsEnabled -Value 1 -PropertyType DWord -Force | Out-Null

# Write-Host 'FileSystem : NTFS increases the size of its lookaside lists and memory thresholds : Enabled'
# New-ItemProperty -Path $Key -Name NtfsMemoryUsage -Value 2 -PropertyType DWord -Force | Out-Null

Write-Host 'FileSystem : Encrypt paging file : Enabled'
New-ItemProperty -Path $Key -Name NtfsEncryptPagingFile -Value 2 -PropertyType DWord -Force | Out-Null

Write-Host 'FileSystem : Last Access Time feature : Disabled'
New-ItemProperty -Path $Key -Name NtfsDisableLastAccessUpdate -Value 2147483649 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name RefsDisableLastAccessUpdate -Value 1 -PropertyType DWord -Force | Out-Null
