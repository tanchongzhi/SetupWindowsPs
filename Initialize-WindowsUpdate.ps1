param (
    # Use Group Police to configure Windows Update
    [Parameter()]
    [switch]
    $UseGroupPolicy
)

$ErrorActionPreference = 'Stop'

if ([System.Environment]::OSVersion.Version.Major -eq 10) {
    $Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
    $null = (Test-Path -Path $Key -PathType Container) -or (New-Item -Path $Key -Force)

    Write-Host 'Windows Update : Do not include drivers with Windows Updates : Disabled'
    $null = New-ItemProperty -Path $Key -Name ExcludeWUDriversInQualityUpdate -Value 1 -PropertyType DWord -Force
}

$Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
$null = (Test-Path -Path $Key -PathType Container) -or (New-Item -Path $Key -Force)

Write-Host 'Windows Update : Do not display "Install Updates And Shut Down" option in Shut Down Windows dialog box : Enabled'
$null = New-ItemProperty -Path $Key -Name NoAUShutdownOption -Value 1 -PropertyType DWord -Force

Write-Host 'Windows Update : No auto-restart with logged on users for scheduled automatic updates installations : Enabled'
$null = New-ItemProperty -Path $Key -Name NoAutoRebootWithLoggedOnUsers -Value 1 -PropertyType DWord -Force

if ($UseGroupPolicy) {
    $Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
} else {
    $Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update'
}

$null = (Test-Path -Path $Key -PathType Container) -or (New-Item -Path $Key -Force)

Write-Host 'Windows Update : Turn on recommended updates via Automatic Updates : Disabled'
$null = New-ItemProperty -Path $Key -Name IncludeRecommendedUpdates -Value 0 -PropertyType DWord -Force

Write-Host 'Windows Update : Install updates automatically : Enabled'
$null = New-ItemProperty -Path $Key -Name AUOptions -Value 4 -PropertyType DWord -Force
$null = New-ItemProperty -Path $Key -Name NoAutoUpdate -Value 0 -PropertyType DWord -Force

Write-Host 'Windows Update : Scheduled install updates at 12 noon everyday...'
$null = New-ItemProperty -Path $Key -Name ScheduledInstallDay -Value 0 -PropertyType DWord -Force
$null = New-ItemProperty -Path $Key -Name ScheduledInstallTime -Value 12 -PropertyType DWord -Force
