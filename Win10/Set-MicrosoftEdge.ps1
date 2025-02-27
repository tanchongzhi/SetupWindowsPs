$ErrorActionPreference = 'Stop'

Write-Host 'Microsoft Edge Policies : Allow web content on New Tab page : Disabled'
$Keys = @(
    'HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\ServiceUI\',
    'HKCU:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\ServiceUI\'
)
$Keys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null
New-ItemProperty -Path $Keys -Name AllowWebContentOnNewTabPage -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Microsoft Edge Policies : Allow Microsoft Edge to start and load the Start and New Tab page at Windows startup and each time Microsoft Edge is closed : Disabled'
$Keys = @(
    'HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader',
    'HKCU:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader'
)
$Keys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null
New-ItemProperty -Path $Keys -Name AllowTabPreloading -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

$Keys = @(
    'HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main\',
    'HKCU:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main\'
)
$Keys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

Write-Host 'Microsoft Edge Policies : Keep favorites in sync between Internet Explorer and Microsoft Edge : Disabled'
New-ItemProperty -Path $Keys -Name SyncFavoritesBetweenIEAndMicrosoftEdge -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'Microsoft Edge Policies : Prevent the First Run webpage from opening on Microsoft Edge : Enabled'
New-ItemProperty -Path $Keys -Name PreventFirstRunPage -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host 'Microsoft Edge Policies : Allow Microsoft Edge to pre-launch at Windows startup, when the system is idle, and each time Microsoft Edge is closed : Disabled'
New-ItemProperty -Path $Keys -Name AllowPrelaunch -Value 0 -PropertyType DWord -Force | Out-Null
