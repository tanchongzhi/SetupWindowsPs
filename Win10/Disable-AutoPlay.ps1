$ErrorActionPreference = 'Stop'

Write-Host 'AutoPlay Policies : Disallow Autoplay for non-volume devices : Enabled'
$Keys = @(
    'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer\',
    'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer\'
)
$Keys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null
New-ItemProperty -Path $Keys -Name NoAutoplayfornonVolume -Value 1 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

$Keys = @(
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\',
    'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\'
)
$Keys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

Write-Host 'AutoPlay Policies : Turn off Autoplay (All drives) : Enabled'
New-ItemProperty -Path $Keys -Name NoDriveTypeAutoRun -Value 255 -PropertyType DWord -Force | Out-Null

Write-Host 'AutoPlay Policies : Set the default behavior for AutoRun (Do not execute any autorun commands) : Enabled'
New-ItemProperty -Path $Keys -Name NoAutorun -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'AutoPlay Policies : Prevent AutoPlay from remembering user choices : Enabled'
New-ItemProperty -Path $Keys -Name DontSetAutoplayCheckbox -Value 1 -PropertyType DWord -Force | Out-Null
