$ErrorActionPreference = 'Stop'

Write-Host 'Desktop : Show desktop icons : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name HideIcons -Value 0 -Type DWord

Write-Host 'Desktop : Medium icons : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\Shell\Bags\1\Desktop' -Name IconSize -Value 48 -Type DWord

Write-Host 'Desktop : Auto arrange icons : Disabled'
Write-Host 'Desktop : Align icons to grid : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\Shell\Bags\1\Desktop' -Name FFlags -Value 0x40200224 -Type DWord

Write-Host 'Desktop : Show "This PC" icon on the desktop : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel' -Name '{20D04FE0-3AEA-1069-A2D8-08002B30309D}' -Value 0 -Type DWord

Write-Host "Desktop : Show `"$env:USERNAME`" icon on the desktop : Enabled"
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel' -Name '{59031a47-3f72-44a7-89c5-5595fe6b30ee}' -Value 0 -Type DWord
