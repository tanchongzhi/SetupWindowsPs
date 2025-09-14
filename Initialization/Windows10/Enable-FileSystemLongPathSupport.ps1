$ErrorActionPreference = 'Stop'

Write-Host 'FileSystem : Long Paths Support : Enabled'
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\FileSystem' -Name LongPathsEnabled -Value 1 -Type DWord
