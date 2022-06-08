$ErrorActionPreference = "Stop"

$Key = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsMediaPlayer\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)

Write-Host "Windows Media Player : Prevent Quick Launch Toolbar Shortcut Creation : Enabled"
$null = New-ItemProperty -Path $Key -Name QuickLaunchShortcut -Value no -PropertyType String -Force

Write-Host "Windows Media Player : Prevent Desktop Shortcut Creation : Enabled"
$null = New-ItemProperty -Path $Key -Name DesktopShortcut -Value no -PropertyType String -Force

Write-Host "Windows Media Player : Do Not Show First Use Dialog Boxes : Enabled"
$null = New-ItemProperty -Path $Key -Name GroupPrivacyAcceptance -Value 1 -PropertyType DWord -Force
