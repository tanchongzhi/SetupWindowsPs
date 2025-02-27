$ErrorActionPreference = 'Stop'

#-----------------------------------------------------------------------------------------------------------------------

Write-Host 'System : Shutdown without logon : Disabled'
$Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name ShutdownWithoutLogon -Value 0 -PropertyType DWord -Force | Out-Null

#-----------------------------------------------------------------------------------------------------------------------

$Key = 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\'

Write-Host 'System Network : Restrict anonymous access to named pipes and shares : Enabled'
New-ItemProperty -Path $Key -Name RestrictAnonymous -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'System Network : Restrict anonymous sam access to named pipes and shares : Enabled'
New-ItemProperty -Path $Key -Name RestrictAnonymousSam -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'System Accounts : Limit local account use of blank passwords to console logon only : Enabled'
New-ItemProperty -Path $Key -Name LimitBlankPasswordUse -Value 1 -PropertyType DWord -Force | Out-Null

#-----------------------------------------------------------------------------------------------------------------------

# Write-Host 'Service : Netlogon : Disabled'
# Stop-Service -Name Netlogon -Force -ErrorAction SilentlyContinue
# Set-Service -Name Netlogon -Status Stopped -StartupType Disabled -ErrorAction SilentlyContinue

Write-Host 'Service : Remote Registry : Disabled'
Stop-Service -Name RemoteRegistry -Force -ErrorAction SilentlyContinue
Set-Service -Name RemoteRegistry -Status Stopped -StartupType Disabled -ErrorAction SilentlyContinue
