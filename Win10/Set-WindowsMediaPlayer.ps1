$ErrorActionPreference = 'Stop'

$Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsMediaPlayer\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null

Write-Host 'Windows Media Player Policies : Prevent Quick Launch Toolbar Shortcut Creation : Enabled'
New-ItemProperty -Path $Key -Name QuickLaunchShortcut -Value no -PropertyType String -Force | Out-Null

Write-Host 'Windows Media Player Policies : Prevent Desktop Shortcut Creation : Enabled'
New-ItemProperty -Path $Key -Name DesktopShortcut -Value no -PropertyType String -Force | Out-Null

Write-Host 'Windows Media Player Policies : Do Not Show First Use Dialog Boxes : Enabled'
New-ItemProperty -Path $Key -Name GroupPrivacyAcceptance -Value 1 -PropertyType DWord -Force | Out-Null
