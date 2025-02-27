$ErrorActionPreference = 'Stop'

if ([System.Environment]::OSVersion.Version.Major -eq 6) {
    $Key = 'HKCU:\SOFTWARE\Microsoft\CTF\LangBar\'
    (Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null

    Write-Host 'Language Bar : Show additional icons in taskbar : Disabled'
    New-ItemProperty -Path $Key -Name ExtraIconsOnMinimized -Value 0 -PropertyType DWord -Force | Out-Null

    Write-Host 'Language Bar : Show text labels : Enabled'
    New-ItemProperty -Path $Key -Name Label -Value 1 -PropertyType DWord -Force | Out-Null

    Write-Host 'Language Bar : Docked in the taskbar : Enabled'
    New-ItemProperty -Path $Key -Name ShowStatus -Value 4 -PropertyType DWord -Force | Out-Null
    New-ItemProperty -Path $Key -Name Transparency -Value 255 -PropertyType DWord -Force | Out-Null

    Write-Host 'Language Bar : Auto Adjust : Enabled'
    New-ItemProperty -Path $Key -Name AutoAdjustDeskBand -Value 1 -PropertyType DWord -Force | Out-Null
}
