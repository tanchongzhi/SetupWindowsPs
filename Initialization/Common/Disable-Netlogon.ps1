$ErrorActionPreference = 'Stop'

Write-Host 'Service : Netlogon : Disabled'
Stop-Service -Name Netlogon -Force -ErrorAction SilentlyContinue
Set-Service -Name Netlogon -Status Stopped -StartupType Disabled -ErrorAction SilentlyContinue
