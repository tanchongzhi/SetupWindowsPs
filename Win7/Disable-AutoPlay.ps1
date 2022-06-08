$ErrorActionPreference = "Stop"

Write-Host "AutoPlay : Disabled"

$Keys = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\"
)
$Keys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null
$null = New-ItemProperty -Path $Keys -Name NoDriveTypeAutoRun -Value 255 -PropertyType DWord -Force

#

$Key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\"
$null = New-ItemProperty -Path $Key -Name EnableAutoTray -Value 0 -PropertyType DWord -Force

#

$Key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name DisableAutoplay -Value 1 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "AutoPlay : Set the default action to take no action..."

if ([System.Environment]::OSVersion.Version.Major -eq 6) {
    $Keys = @(
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\MixedContentOnArrival\",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\MixedContentOnArrival\"
    )
}
else {
    $Keys = @(
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\StorageOnArrival\",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\CameraAlternate\ShowPicturesOnArrival\",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\StorageOnArrival\",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\CameraAlternate\ShowPicturesOnArrival\"
    )
}

$null = $Keys | ForEach-Object {
    if (Test-Path -Path $_) {
        Set-Item -Path $_ -Value MSTakeNoAction -Force
    }
    else {
        New-Item -Path $_ -Value MSTakeNoAction -Force
    }
}
