$ErrorActionPreference = 'Stop'

$policyKeys = @(
    'HKLM:\Software\Policies\Microsoft\Windows\CloudContent',
    'HKCU:\Software\Policies\Microsoft\Windows\CloudContent'
)
$policyKeys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

#

Write-Host 'Cloud Content Policy : Do not show Windows Tips : Enabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent' -Name DisableSoftLanding -Value 1 -Type DWord

Write-Host 'Cloud Content Policy : Turn off cloud optimized content : Enabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent' -Name DisableCloudOptimizedContent -Value 1 -Type DWord

Write-Host 'Cloud Content Policy : Turn off Microsoft consumer experiences : Enabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent' -Name DisableWindowsConsumerFeatures -Value 1 -Type DWord

Write-Host 'Cloud Content Policy : Turn off cloud consumer account state content : Enabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent' -Name DisableConsumerAccountStateContent -Value 1 -Type DWord

Write-Host 'Cloud Content Policy : Configure Windows spotlight on lock screen : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Windows\CloudContent' -Name ConfigureWindowsSpotlight -Value 2 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Windows\CloudContent' -Name IncludeEnterpriseSpotlight -Value 0 -Type DWord

Write-Host 'Cloud Content Policy : Do not use diagnostic data for tailored experiences : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Windows\CloudContent' -Name DisableTailoredExperiencesWithDiagnosticData -Value 1 -Type DWord

Write-Host 'Cloud Content Policy : Do not suggest third-party content in Windows spotlight : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Windows\CloudContent' -Name DisableThirdPartySuggestions -Value 1 -Type DWord

Write-Host 'Cloud Content Policy : Turn off all Windows spotlight features : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Windows\CloudContent' -Name DisableWindowsSpotlightFeatures -Value 1 -Type DWord

Write-Host 'Cloud Content Policy : Turn off Spotlight collection on Desktop : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Windows\CloudContent' -Name DisableSpotlightCollectionOnDesktop -Value 1 -Type DWord

Write-Host 'Cloud Content Policy : Turn off the Windows Welcome Experience : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Windows\CloudContent' -Name DisableWindowsSpotlightWindowsWelcomeExperience -Value 1 -Type DWord

Write-Host 'Cloud Content Policy : Turn off Windows Spotlight on Action Center : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Windows\CloudContent' -Name DisableWindowsSpotlightOnActionCenter -Value 1 -Type DWord

Write-Host 'Cloud Content Policy : Turn off Windows Spotlight on Settings : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Windows\CloudContent' -Name DisableWindowsSpotlightOnSettings -Value 1 -Type DWord
