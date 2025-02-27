$ErrorActionPreference = 'Stop'

$Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null

Write-Host 'Cloud Content Policies : Do not show Windows Tips : Enabled'
New-ItemProperty -Path $Key -Name DisableSoftLanding -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Cloud Content Policies : Turn off cloud optimized content : Enabled'
New-ItemProperty -Path $Key -Name DisableCloudOptimizedContent -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Cloud Content Policies : Turn off Microsoft consumer experiences : Enabled'
New-ItemProperty -Path $Key -Name DisableWindowsConsumerFeatures -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Cloud Content Policies : Turn off cloud consumer account state content : Enabled'
New-ItemProperty -Path $Key -Name DisableConsumerAccountStateContent -Value 1 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

$Key = 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null

Write-Host 'Cloud Content Policies : Configure Windows spotlight on lock screen : Disabled'
New-ItemProperty -Path $Key -Name ConfigureWindowsSpotlight -Value 2 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name IncludeEnterpriseSpotlight -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'Cloud Content Policies : Do not use diagnostic data for tailored experiences : Enabled'
New-ItemProperty -Path $Key -Name DisableTailoredExperiencesWithDiagnosticData -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Cloud Content Policies : Do not suggest third-party content in Windows spotlight : Enabled'
New-ItemProperty -Path $Key -Name DisableThirdPartySuggestions -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Cloud Content Policies : Turn off all Windows spotlight features : Enabled'
New-ItemProperty -Path $Key -Name DisableWindowsSpotlightFeatures -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Cloud Content Policies : Turn off Spotlight collection on Desktop : Enabled'
New-ItemProperty -Path $Key -Name DisableSpotlightCollectionOnDesktop -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Cloud Content Policies : Turn off the Windows Welcome Experience : Enabled'
New-ItemProperty -Path $Key -Name DisableWindowsSpotlightWindowsWelcomeExperience -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Cloud Content Policies : Turn off Windows Spotlight on Action Center : Enabled'
New-ItemProperty -Path $Key -Name DisableWindowsSpotlightOnActionCenter -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Cloud Content Policies : Turn off Windows Spotlight on Settings : Enabled'
New-ItemProperty -Path $Key -Name DisableWindowsSpotlightOnSettings -Value 1 -PropertyType DWord -Force | Out-Null
