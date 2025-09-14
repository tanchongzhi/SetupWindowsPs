$ErrorActionPreference = 'Stop'

$policyKeys = @(
    'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
)
$policyKeys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

#

Write-Host 'System : Shutdown without logon : Disabled'
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name ShutdownWithoutLogon -Value 0 -Type DWord
