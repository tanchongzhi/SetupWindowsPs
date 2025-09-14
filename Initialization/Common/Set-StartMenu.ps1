$ErrorActionPreference = 'Stop'

$policyKeys = @(
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',
    'HKCU:\Software\Policies\Microsoft\Windows\Explorer'
)

$osVersion = [System.Environment]::OSVersion.Version

if ($osVersion.Major -ge 10) {
    $policyKeys += @(
        'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',
        'HKLM:\Software\Policies\Microsoft\Windows\Explorer'
    )
}

$policyKeys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

#

Write-Host 'Start Menu Policy : Clear history of recently opened documents on exit : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name ClearRecentDocsOnExit -Value 1 -Type DWord

Write-Host 'Start Menu Policy : Clear the recent programs list for new users : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name ClearRecentProgForNewUserInStartMenu -Value 1 -Type DWord

if (($osVersion.Major -ge 10) -or (($osVersion.Major -eq 6) -and ($osVersion.Minor -ge 2))) {
    # Windows 8+
    Write-Host 'Start Menu Policy : Clear tile notifications during log on : Enabled'
    Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Windows\Explorer' -Name ClearTilesOnExit -Value 1 -Type DWord
}

if (($osVersion.Major -eq 6) -and ($osVersion.Minor -eq 1)) {
    # Windows 7
    Write-Host 'Start Menu Policy : Do not allow pinning items in Jump Lists : Enabled'
    Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Windows\Explorer' -Name NoPinningToDestinations -Value 1 -Type DWord
}

Write-Host 'Start Menu Policy : Do not keep history of recently opened documents : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name NoRecentDocsHistory -Value 1 -Type DWord

if ($osVersion.Major -ge 10) {
    Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name NoRecentDocsHistory -Value 1 -Type DWord
}

if ($osVersion.Major -ge 10) {
    Write-Host 'Start Menu Policy : Remove "Recently added" list from Start Menu : Enabled'
    Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Explorer' -Name HideRecentlyAddedApps -Value 1 -Type DWord
    Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Windows\Explorer' -Name HideRecentlyAddedApps -Value 1 -Type DWord

    Write-Host 'Start Menu Policy : Hide "Most used" list from Start Menu : Enabled'
    Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Explorer' -Name ShowOrHideMostUsedApps -Value 2 -Type DWord
    Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Windows\Explorer' -Name ShowOrHideMostUsedApps -Value 2 -Type DWord
}

Write-Host 'Start Menu Policy : Remove frequent programs list from the Start Menu : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name NoStartMenuMFUprogramsList -Value 1 -Type DWord

if ($osVersion.Major -ge 10) {
    Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name NoStartMenuMFUprogramsList -Value 1 -Type DWord
}

Write-Host 'Start Menu Policy : Remove Recent Items menu from Start Menu : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name NoRecentDocsMenu -Value 1 -Type DWord

Write-Host 'Start Menu Policy : Turn off user tracking : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name NoInstrumentation -Value 1 -Type DWord

Write-Host 'Start Menu : Show recommended files in Start, recent files in File Explorer, and items in Jump Lists: Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name Start_TrackDocs -Value 0 -Type DWord

Write-Host 'Start Menu : Let Windows track app launches to improve Start and search results: Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name Start_TrackProgs -Value 0 -Type DWord
