$ErrorActionPreference = 'Stop'

$osVersion = [System.Environment]::OSVersion.Version

if (($osVersion.Major -eq 6) -and ($osVersion.Minor -le 1)) {
    Write-Host 'Language Bar : Show additional icons in taskbar : Disabled'
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\CTF\LangBar' -Name ExtraIconsOnMinimized -Value 0 -Type DWord

    Write-Host 'Language Bar : Show text labels : Enabled'
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\CTF\LangBar' -Name Label -Value 1 -Type DWord

    Write-Host 'Language Bar : Docked in the taskbar : Enabled'
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\CTF\LangBar' -Name ShowStatus -Value 4 -Type DWord
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\CTF\LangBar' -Name Transparency -Value 255 -Type DWord

    Write-Host 'Language Bar : Auto Adjust : Enabled'
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\CTF\LangBar' -Name AutoAdjustDeskBand -Value 1 -Type DWord
}
