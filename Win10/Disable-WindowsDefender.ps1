$ErrorActionPreference = "Stop"

Write-Host "You should turn off Windows Defender tamper protection in Windows Security Center first."

$confirmation = Read-Host -Prompt "Continue? Y/n"

if ($confirmation -ne "y") {
    exit 0
}

$Key = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)

Write-Host "Windows Defender Antivirus : Turn off Microsoft Defender Antivirus : Enabled"
$null = New-ItemProperty -Path $Key -Name DisableAntiSpyware -Value 1 -PropertyType DWord -Force

Write-Host "Windows Defender Antivirus : Allow antimalware service to remain running always : Disabled"
$null = New-ItemProperty -Path $Key -Name ServiceKeepAlive -Value 0 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

$Key = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)

Write-Host "Windows Defender Antivirus : Real-time Protection : Turn off real-time protection : Enabled"
$null = New-ItemProperty -Path $Key -Name DisableRealtimeMonitoring -Value 1 -PropertyType DWord -Force

Write-Host "Windows Defender Antivirus : Real-time Protection : Scan all downloaded files and attachments : Disabled"
$null = New-ItemProperty -Path $Key -Name DisableIOAVProtection -Value 1 -PropertyType DWord -Force
