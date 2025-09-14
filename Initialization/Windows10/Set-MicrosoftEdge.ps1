$ErrorActionPreference = 'Stop'

$policyKeys = @(
    'HKLM:\Software\Policies\Microsoft\MicrosoftEdge\Main',
    'HKCU:\Software\Policies\Microsoft\MicrosoftEdge\Main',
    'HKLM:\Software\Policies\Microsoft\MicrosoftEdge\ServiceUI',
    'HKCU:\Software\Policies\Microsoft\MicrosoftEdge\ServiceUI',
    'HKLM:\Software\Policies\Microsoft\MicrosoftEdge\TabPreloader',
    'HKCU:\Software\Policies\Microsoft\MicrosoftEdge\TabPreloader'
)
$policyKeys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

#

Write-Host 'Microsoft Edge : Allow Microsoft Edge to pre-launch at Windows startup, when the system is idle, and each time Microsoft Edge is closed : Disabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\MicrosoftEdge\Main' -Name AllowPrelaunch -Value 0 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\MicrosoftEdge\Main' -Name AllowPrelaunch -Value 0 -Type DWord

Write-Host 'Microsoft Edge : Keep favorites in sync between Internet Explorer and Microsoft Edge : Disabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\MicrosoftEdge\Main' -Name SyncFavoritesBetweenIEAndMicrosoftEdge -Value 0 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\MicrosoftEdge\Main' -Name SyncFavoritesBetweenIEAndMicrosoftEdge -Value 0 -Type DWord

Write-Host 'Microsoft Edge : Prevent the First Run webpage from opening on Microsoft Edge : Enabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\MicrosoftEdge\Main' -Name PreventFirstRunPage -Value 1 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\MicrosoftEdge\Main' -Name PreventFirstRunPage -Value 1 -Type DWord

Write-Host 'Microsoft Edge : Allow web content on New Tab page : Disabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\MicrosoftEdge\ServiceUI' -Name AllowWebContentOnNewTabPage -Value 0 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\MicrosoftEdge\ServiceUI' -Name AllowWebContentOnNewTabPage -Value 0 -Type DWord

Write-Host 'Microsoft Edge : Allow Microsoft Edge to start and load the Start and New Tab page at Windows startup and each time Microsoft Edge is closed : Disabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\MicrosoftEdge\TabPreloader' -Name AllowTabPreloading -Value 0 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\MicrosoftEdge\TabPreloader' -Name AllowTabPreloading -Value 0 -Type DWord
