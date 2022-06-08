$ErrorActionPreference = "Stop"

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "System : Shutdown without logon : Disabled"
$Key = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name ShutdownWithoutLogon -Value 0 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

$Key = "HKLM:\System\CurrentControlSet\Control\Lsa\"

Write-Host "System Network : Restrict anonymous access to named pipes and shares : Enabled"
$null = New-ItemProperty -Path $Key -Name RestrictAnonymous -Value 1 -PropertyType DWord -Force

Write-Host "System Network : Restrict anonymous sam access to named pipes and shares : Enabled"
$null = New-ItemProperty -Path $Key -Name RestrictAnonymousSam -Value 1 -PropertyType DWord -Force

Write-Host "System Accounts : Limit local account use of blank passwords to console logon only : Enabled"
$null = New-ItemProperty -Path $Key -Name LimitBlankPasswordUse -Value 1 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

# Write-Host "Service : Netlogon : Disabled"
# Stop-Service -Name Netlogon -Force -ErrorAction SilentlyContinue
# Set-Service -Name Netlogon -Status Stopped -StartupType Disabled -ErrorAction SilentlyContinue

Write-Host "Service : Remote Registry : Disabled"
Stop-Service -Name RemoteRegistry -Force -ErrorAction SilentlyContinue
Set-Service -Name RemoteRegistry -Status Stopped -StartupType Disabled -ErrorAction SilentlyContinue
