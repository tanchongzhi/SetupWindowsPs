$ErrorActionPreference = 'Stop'

$policyKeys = @(
    'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting',
    'HKCU:\Software\Policies\Microsoft\Windows\Windows Error Reporting'
)
$policyKeys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

#

Write-Host 'Windows Error Reporting : Do not send additional data : Enabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Name DontSendAdditionalData -Value 1 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Name DontSendAdditionalData -Value 1 -Type DWord

$osVersion = [System.Environment]::OSVersion.Version

if (($osVersion.Major -ge 10) -or (($osVersion.Major -eq 6) -and ($osVersion.Minor -ge 2))) {
    Write-Host 'Windows Error Reporting : Automatically send memory dumps for OS-generated error reports : Disabled'
    Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Name AutoApproveOSDumps -Value 0 -Type DWord
    Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Name AutoApproveOSDumps -Value 0 -Type DWord
}
