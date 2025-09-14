$ErrorActionPreference = 'Stop'

$policyKeys = @(
    'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',
    'HKLM:\Software\Policies\Microsoft\Windows\Explorer',
    'HKCU:\Software\Policies\Microsoft\Windows\Explorer'
)
$policyKeys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

#

Write-Host 'AutoPlay Policy : Turn off Autoplay (All drives) : Enabled'
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name NoDriveTypeAutoRun -Value 255 -Type DWord -Force
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name NoDriveTypeAutoRun -Value 255 -Type DWord -Force

Write-Host 'AutoPlay Policy : Set the default behavior for AutoRun (Do not execute any autorun commands) : Enabled'
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name NoAutorun -Value 1 -Type DWord -Force
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name NoAutorun -Value 1 -Type DWord -Force

Write-Host 'AutoPlay Policy : Prevent AutoPlay from remembering user choices : Enabled'
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name DontSetAutoplayCheckbox -Value 1 -Type DWord -Force
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name DontSetAutoplayCheckbox -Value 1 -Type DWord -Force

Write-Host 'AutoPlay Policy : Disallow Autoplay for non-volume devices : Enabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Explorer' -Name NoAutoplayfornonVolume -Value 1 -Type DWord -Force
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Windows\Explorer' -Name NoAutoplayfornonVolume -Value 1 -Type DWord -Force

Write-Host 'AutoPlay : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers' -Name DisableAutoplay -Value 1 -Type DWord -Force

Write-Host 'AutoPlay : Set the default action to take no action...'

$autoplayHandlerKeys = (
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers'
)
$null = New-Item -Path $autoplayHandlerKeys -Force

$autoplayHandlerKeys = (
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\AutorunINFLegacyArrival',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\HandleBDBurningOnArrival',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\HandleCDBurningOnArrival',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\HandleDVDBurningOnArrival',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\PlayBluRayOnArrival',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\PlayCDAudioOnArrival',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\PlayDVDAudioOnArrival',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\PlayDVDMovieOnArrival',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\PlayEnhancedCDOnArrival',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\PlayEnhancedDVDOnArrival',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\PlaySuperVideoCDMovieOnArrival',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\PlayVideoCDMovieOnArrival',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\AutorunINFLegacyArrival',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\HandleBDBurningOnArrival',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\HandleCDBurningOnArrival',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\HandleDVDBurningOnArrival',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\PlayBluRayOnArrival',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\PlayCDAudioOnArrival',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\PlayDVDAudioOnArrival',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\PlayDVDMovieOnArrival',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\PlayEnhancedCDOnArrival',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\PlayEnhancedDVDOnArrival',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\PlaySuperVideoCDMovieOnArrival',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\PlayVideoCDMovieOnArrival'
)

$osVersion = [System.Environment]::OSVersion.Version

if ($osVersion.Major -ge 10) {
    # Windows 10+
    $autoplayHandlerKeys += @(
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\CameraAlternate\ShowPicturesOnArrival',
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\CameraAlternate\ShowPicturesOnArrival'
    )
}

# Prefer to use separate media settings for better code compatibility
if ($false -and (
        ($osVersion.Major -ge 10) -or
        (($osVersion.Major -eq 6) -and ($osVersion.Minor -ge 2))
    )) {
    # Windows 8+

    $autoplayHandlerKeys += @(
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\StorageOnArrival',
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\StorageOnArrival'
    )
} else {
    # Windows 7+

    $autoplayHandlerKeys += @(
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\MixedContentOnArrival',
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\PlayMusicFilesOnArrival',
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\PlayVideoFilesOnArrival',
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\ShowPicturesOnArrival',
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\MixedContentOnArrival',
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\PlayMusicFilesOnArrival',
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\PlayVideoFilesOnArrival',
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\ShowPicturesOnArrival'
    )
}

$null = $autoplayHandlerKeys | ForEach-Object {
    if (Test-Path -Path $_) {
        Set-Item -Path $_ -Value MSTakeNoAction -Force
    } else {
        New-Item -Path $_ -Value MSTakeNoAction -Force
    }
}
