$ErrorActionPreference = "Stop"

$Key = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)

Write-Host "Cloud Content : Do not show Windows Tips : Enabled"
$null = New-ItemProperty -Path $Key -Name DisableSoftLanding -Value 1 -PropertyType DWord -Force

Write-Host "Cloud Content : Turn off cloud optimized content : Enabled"
$null = New-ItemProperty -Path $Key -Name DisableCloudOptimizedContent -Value 1 -PropertyType DWord -Force

Write-Host "Cloud Content : Turn off Microsoft consumer experiences : Enabled"
$null = New-ItemProperty -Path $Key -Name DisableWindowsConsumerFeatures -Value 1 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

$Key = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)

Write-Host "Cloud Content : Configure Windows spotlight on lock screen : Disabled"
$null = New-ItemProperty -Path $Key -Name ConfigureWindowsSpotlight -Value 2 -PropertyType DWord -Force
$null = New-ItemProperty -Path $Key -Name IncludeEnterpriseSpotlight -Value 0 -PropertyType DWord -Force

Write-Host "Cloud Content : Do not suggest third-party content in Windows spotlight : Enabled"
$null = New-ItemProperty -Path $Key -Name DisableThirdPartySuggestions -Value 1 -PropertyType DWord -Force

Write-Host "Cloud Content : Do not use diagnostic data for tailored experiences : Enabled"
$null = New-ItemProperty -Path $Key -Name DisableTailoredExperiencesWithDiagnosticData -Value 1 -PropertyType DWord -Force

Write-Host "Cloud Content : Turn off all Windows spotlight features : Enabled"
$null = New-ItemProperty -Path $Key -Name DisableWindowsSpotlightFeatures -Value 1 -PropertyType DWord -Force

Write-Host "Cloud Content : Turn off the Windows Welcome Experience : Enabled"
$null = New-ItemProperty -Path $Key -Name DisableWindowsSpotlightWindowsWelcomeExperience -Value 1 -PropertyType DWord -Force

Write-Host "Cloud Content : Turn off Windows Spotlight on Action Center : Enabled"
$null = New-ItemProperty -Path $Key -Name DisableWindowsSpotlightOnActionCenter -Value 1 -PropertyType DWord -Force

Write-Host "Cloud Content : Turn off Windows Spotlight on Settings : Enabled"
$null = New-ItemProperty -Path $Key -Name DisableWindowsSpotlightOnSettings -Value 1 -PropertyType DWord -Force
