$ErrorActionPreference = 'Stop'

Write-Host 'AutoPlay : Disabled'

$Keys = @(
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\',
    'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\'
)
$Keys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null
New-ItemProperty -Path $Keys -Name NoDriveTypeAutoRun -Value 255 -PropertyType DWord -Force | Out-Null

#

$Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\'
New-ItemProperty -Path $Key -Name EnableAutoTray -Value 0 -PropertyType DWord -Force | Out-Null

#

$Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name DisableAutoplay -Value 1 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'AutoPlay : Set the default action to take no action...'

if ([System.Environment]::OSVersion.Version.Major -eq 6) {
    $Keys = @(
        'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\MixedContentOnArrival\',
        'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\MixedContentOnArrival\'
    )
} else {
    $Keys = @(
        'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\StorageOnArrival\',
        'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\CameraAlternate\ShowPicturesOnArrival\',
        'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\StorageOnArrival\',
        'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\CameraAlternate\ShowPicturesOnArrival\'
    )
}

$Keys | ForEach-Object {
    if (Test-Path -Path $_) {
        Set-Item -Path $_ -Value MSTakeNoAction -Force
    } else {
        New-Item -Path $_ -Value MSTakeNoAction -Force
    }
} | Out-Null
