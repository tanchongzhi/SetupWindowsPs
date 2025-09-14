$ErrorActionPreference = 'Stop'

$policyKeys = @(
    'HKLM:\Software\Policies\Microsoft\WindowsMediaPlayer'
)
$policyKeys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

#

Write-Host 'Windows Media Sharing : Prevent Media Sharing : Enabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\WindowsMediaPlayer' -Name PreventLibrarySharing -Value 1 -Type DWord

Write-Host 'Windows Media Sharing : Windows Media Player Network Sharing Service : Disabled'
Stop-Service -Name WMPNetworkSvc -Force -ErrorAction SilentlyContinue
Set-Service -Name WMPNetworkSvc -Status Stopped -StartupType Disabled -ErrorAction SilentlyContinue

Write-Host 'Windows Media Sharing : Scheduled Tasks : \Microsoft\Windows\Windows Media Sharing\* : Disabled'
$null = schtasks /Query /FO LIST |
    Select-String -Pattern '\Microsoft\Windows\Windows Media Sharing\' -SimpleMatch |
    ForEach-Object { schtasks /Change /Disable /TN "$($_.Line.Split(':', 2)[1].Trim())" }
