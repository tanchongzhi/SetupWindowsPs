Write-Host 'System : AutoRun : Disabled'

$Key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
$null = (Test-Path -Path $Key -PathType Container) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name NoDriveTypeAutoRun -Value 255 -PropertyType DWord -Force

$Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
$null = (Test-Path -Path $Key -PathType Container) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name NoDriveTypeAutoRun -Value 255 -PropertyType DWord -Force
