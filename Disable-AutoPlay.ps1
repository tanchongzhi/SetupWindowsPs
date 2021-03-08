Write-Host 'System : AutoPlay : Disabled'

$Key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer'
$null = New-ItemProperty -Path $Key -Name EnableAutoTray -Value 0 -PropertyType DWord -Force

$Key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers'
$null = (Test-Path -Path $Key -PathType Container) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name DisableAutoplay -Value 1 -PropertyType DWord -Force

Write-Host 'System : AutoPlay : Set the default action to take no action...'

if ([System.Environment]::OSVersion.Version.Major -eq 6) {
    $KeyList = @(
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\MixedContentOnArrival',
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\MixedContentOnArrival'
    )
} else {
    $KeyList = @(
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\StorageOnArrival',
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\CameraAlternate\ShowPicturesOnArrival',
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\StorageOnArrival',
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\CameraAlternate\ShowPicturesOnArrival'
    )
}

$null = $KeyList | ForEach-Object -Process {
    if (Test-Path -Path $_ -PathType Container) {
        Set-Item -Path $_ -Value MSTakeNoAction -Force
    } else {
        New-Item -Path $_ -Value MSTakeNoAction -Force
    }
}
