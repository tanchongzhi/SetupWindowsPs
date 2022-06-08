$ErrorActionPreference = "Stop"

if ([System.Environment]::OSVersion.Version.Major -eq 6) {
    $Key = "HKCU:\Software\Microsoft\CTF\LangBar\"
    $null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)

    Write-Host "Language Bar : Show additional icons in taskbar : Disabled"
    $null = New-ItemProperty -Path $Key -Name ExtraIconsOnMinimized -Value 0 -PropertyType DWord -Force

    Write-Host "Language Bar : Show text labels : Enabled"
    $null = New-ItemProperty -Path $Key -Name Label -Value 1 -PropertyType DWord -Force

    Write-Host "Language Bar : Docked in the taskbar : Enabled"
    $null = New-ItemProperty -Path $Key -Name ShowStatus -Value 4 -PropertyType DWord -Force
    $null = New-ItemProperty -Path $Key -Name Transparency -Value 255 -PropertyType DWord -Force

    Write-Host "Language Bar : Auto Adjust : Enabled"
    $null = New-ItemProperty -Path $Key -Name AutoAdjustDeskBand -Value 1 -PropertyType DWord -Force
}
