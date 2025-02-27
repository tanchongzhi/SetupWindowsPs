param (
    # Use Group Police to configure Windows Update
    [Parameter()]
    [switch]
    $UseGroupPolicy
)

$ErrorActionPreference = 'Stop'

$Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null

Write-Host 'Windows Update : Do not display 'Install Updates And Shut Down" option in Shut Down Windows dialog box : Enabled"
New-ItemProperty -Path $Key -Name NoAUShutdownOption -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Windows Update : No auto-restart with logged on users for scheduled automatic updates installations : Enabled'
New-ItemProperty -Path $Key -Name NoAutoRebootWithLoggedOnUsers -Value 1 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

if ($UseGroupPolicy) {
    $Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\'
} else {
    $Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\'
}

(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null

Write-Host 'Windows Update : Turn on recommended updates via Automatic Updates : Disabled'
New-ItemProperty -Path $Key -Name IncludeRecommendedUpdates -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'Windows Update : Install updates automatically : Enabled'
New-ItemProperty -Path $Key -Name AUOptions -Value 4 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name NoAutoUpdate -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'Windows Update : Scheduled install updates at 12 noon everyday...'
New-ItemProperty -Path $Key -Name ScheduledInstallDay -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name ScheduledInstallTime -Value 12 -PropertyType DWord -Force | Out-Null
