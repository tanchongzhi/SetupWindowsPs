$ErrorActionPreference = 'Stop'

Write-Host 'Remote Desktop Server: Disabled'
$Key = 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\'
New-ItemProperty -Path $Key -Name fDenyTSConnections -Value 1 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Service : Remote Desktop Configuration : Disabled'
Stop-Service -Name SessionEnv -Force -ErrorAction SilentlyContinue
Set-Service -Name SessionEnv -Status Stopped -StartupType Disabled -ErrorAction SilentlyContinue

Write-Host 'Service : Remote Desktop Services : Disabled'
Stop-Service -Name TermService -Force -ErrorAction SilentlyContinue
Set-Service -Name TermService -Status Stopped -StartupType Disabled -ErrorAction SilentlyContinue

Write-Host 'Service : Remote Desktop Services UserMode Port Redirector : Disabled'
Stop-Service -Name UmRdpService -Force -ErrorAction SilentlyContinue
Set-Service -Name UmRdpService -Status Stopped -StartupType Disabled -ErrorAction SilentlyContinue
