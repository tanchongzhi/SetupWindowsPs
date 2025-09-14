$ErrorActionPreference = 'Stop'

Write-Host 'Service : Remote Registry : Disabled'
Stop-Service -Name RemoteRegistry -Force -ErrorAction SilentlyContinue
Set-Service -Name RemoteRegistry -Status Stopped -StartupType Disabled -ErrorAction SilentlyContinue
