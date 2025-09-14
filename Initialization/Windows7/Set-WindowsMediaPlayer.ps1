$ErrorActionPreference = 'Stop'

$policyKeys = @(
    'HKLM:\Software\Policies\Microsoft\WindowsMediaPlayer',
    'HKCU:\Software\Policies\Microsoft\WindowsMediaCenter',
    'HKLM:\Software\Policies\Microsoft\WMDRM'
)
$policyKeys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

#

Write-Host 'Windows Media Center Policy : Windows Media Center : Disabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\WindowsMediaPlayer' -Name MediaCenter -Value 1 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\WindowsMediaCenter' -Name MediaCenter -Value 1 -Type DWord

Write-Host 'Windows Media Player Policy : Do Not Show First Use Dialog Boxes : Enabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\WindowsMediaPlayer' -Name GroupPrivacyAcceptance -Value 1 -Type DWord

Write-Host 'Windows Media Player Policy : Prevent Quick Launch Toolbar Shortcut Creation : Enabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\WindowsMediaPlayer' -Name QuickLaunchShortcut -Value no -Type String

Write-Host 'Windows Media Player Policy : Prevent Desktop Shortcut Creation : Enabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\WindowsMediaPlayer' -Name DesktopShortcut -Value no -Type String

Write-Host 'Windows Media Player Policy : Prevent Automatic Updates : Enabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\WindowsMediaPlayer' -Name DisableAutoUpdate -Value 1 -Type DWord

Write-Host 'Windows Media Player Policy : Prevent Windows Media DRM Internet Access : Enabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\WMDRM' -Name DisableOnline -Value 1 -Type DWord

Write-Host 'Windows Media Player : Do Not Show First Use Dialog Boxes : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\MediaPlayer\Preferences' -Name FirstRun -Value 0 -Type DWord

Write-Host 'Windows Media Player : Media Library Settings : Add video files found in the Pictures library : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\MediaPlayer\Preferences' -Name AddVideosFromPicturesLibrary -Value 0 -Type DWord

Write-Host 'Windows Media Player : Media Library Settings : Add volume leveling information values for new files : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\MediaPlayer\Preferences' -Name AddVolumeLevelingToNewFiles -Value 0 -Type DWord

Write-Host 'Windows Media Player : Media Library Settings : Delete files from computer when deleted fom library : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\MediaPlayer\Preferences' -Name DeleteRemovesFromComputer -Value 0 -Type DWord

Write-Host 'Windows Media Player : Media Library Settings : Automatically preview songs on track title hover : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\MediaPlayer\Preferences' -Name HoverPreviewAutoPlay -Value 0 -Type DWord

Write-Host 'Windows Media Player : Automatic media information updates for files : Retrieve additional information fom the Internet : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\MediaPlayer\Preferences' -Name MetadataRetrieval -Value 0 -Type DWord

Write-Host 'Windows Media Player : Automatic media information updates for files : Rename music files using rip music settings : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\MediaPlayer\Preferences' -Name AutoRename -Value 0 -Type DWord

Write-Host 'Windows Media Player : Automatic media information updates for files : Rearrange music in rip music folder, using rip music settings : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\MediaPlayer\Preferences' -Name AutoOrganize -Value 0 -Type DWord

Write-Host 'Windows Media Player : Automatic media information updates for files : Maintain my star ratings as global ratings in fles : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\MediaPlayer\Preferences' -Name FlushRatingsToFiles -Value 0 -Type DWord

Write-Host 'Windows Media Player : Privacy : Download usage rights automatically when I play or sync a file : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\MediaPlayer\Preferences' -Name SilentAcquisition -Value 0 -Type DWord

Write-Host 'Windows Media Player : Privacy : Automatically check if protected files need to be refreshed : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\MediaPlayer\Preferences' -Name DisableLicenseRefresh -Value 1 -Type DWord

Write-Host 'Windows Media Player : Privacy : Set clock on devices automatically : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\MediaPlayer\Preferences' -Name SilentDRMConfiguration -Value 0 -Type DWord

Write-Host 'Windows Media Player : Privacy : Send unique Player ID to content providers : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\MediaPlayer\Preferences' -Name SendUserGUID -Value ([byte[]]@(0)) -Type Binary

Write-Host 'Windows Media Player : Privacy : Windows Media Player Customer Experience Improvement Program : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\MediaPlayer\Preferences' -Name UsageTracking -Value 0 -Type DWord

Write-Host 'Windows Media Player : Privacy : Store and display a list of recent/frequently played : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\MediaPlayer\Preferences' -Name DisableMRUMusic -Value 0 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\MediaPlayer\Preferences' -Name DisableMRUPictures -Value 0 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\MediaPlayer\Preferences' -Name DisableMRUPlaylists -Value 0 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\MediaPlayer\Preferences' -Name DisableMRUVideo -Value 0 -Type DWord

Write-Host 'Windows Media Player : Player settings : Allow screen saver during playback : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\MediaPlayer\Preferences' -Name EnableScreensaver -Value 0 -Type DWord

Write-Host 'Windows Media Player : Player settings : Add local media files to library when played : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\MediaPlayer\Preferences' -Name AutoAddMusicToLibrary -Value 0 -Type DWord

Write-Host 'Windows Media Player : Player settings : Add remote media files to library when played : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\MediaPlayer\Preferences' -Name AutoAddUNC -Value 0 -Type DWord

Write-Host 'Windows Media Player : Player settings : Connect to the Internet (overrides other commands) : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\MediaPlayer\Preferences' -Name ForceOnline -Value 0 -Type DWord

Write-Host 'Windows Media Player : Player settings : Save recently used to the Jumplist instead of frequently used : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\MediaPlayer\Preferences' -Name UsageLoggerCategories -Value 1 -Type DWord

Write-Host 'Windows Media Player : Service : Windows Media Center Receiver Service : Disabled'
Stop-Service -Name ehRecvr -Force -ErrorAction SilentlyContinue
Set-Service -Name ehRecvr -Status Stopped -StartupType Manual -ErrorAction SilentlyContinue

Write-Host 'Windows Media Player : Service : Windows Media Center Scheduler Service : Disabled'
Stop-Service -Name ehSched -Force -ErrorAction SilentlyContinue
Set-Service -Name ehSched -Status Stopped -StartupType Manual -ErrorAction SilentlyContinue

Write-Host 'Windows Media Player : Service : Media Center Extender Service : Disabled'
Stop-Service -Name Mcx2Svc -Force -ErrorAction SilentlyContinue
Set-Service -Name Mcx2Svc -Status Stopped -StartupType Disabled -ErrorAction SilentlyContinue

Write-Host 'Windows Media Player : Scheduled Tasks : \Microsoft\Windows\Media Center\* : Disabled'
$null = schtasks /Query /FO LIST |
    Select-String -Pattern '\Microsoft\Windows\Media Center\' -SimpleMatch |
    ForEach-Object { schtasks /Change /Disable /TN "$($_.Line.Split(':', 2)[1].Trim())" }
