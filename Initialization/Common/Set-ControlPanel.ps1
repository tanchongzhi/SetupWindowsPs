$ErrorActionPreference = 'Stop'

$settingKeys = @(
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel'
)
$settingKeys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

#

Write-Host 'Control Panel : View by small icons : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel' -Name AllItemsIconView -Value 1 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel' -Name StartupPage -Value 1 -Type DWord
