$ErrorActionPreference = 'Stop'

Write-Host 'Privacy : Let apps using advertising ID to make ads more interesting to you : Disabled'
$Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name Enabled -Value 0 -PropertyType DWord -Force | Out-Null
Remove-ItemProperty -Path $Key -Name Id -Force -ErrorAction SilentlyContinue

#-------------------------------------------------------------------------------

Write-Host 'Privacy : Let Windows track app launches to improve Start and search results : Disabled'
$Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name Start_TrackProgs -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Privacy : Let websites provide locally relevant content by accessing my language list : Disabled'
$Key = 'HKCU:\SOFTWARE\Microsoft\Internet Explorer\International\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
Remove-ItemProperty -Path $Key -Name AcceptLanguage -Force -ErrorAction SilentlyContinue

#-------------------------------------------------------------------------------

Write-Host 'Privacy : Show me suggested content in the Settings app : Disabled'
$Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name 'SubscribedContent-310093Enabled' -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name 'SubscribedContent-338388Enabled' -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name 'SubscribedContent-338389Enabled' -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name 'SubscribedContent-338393Enabled' -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name 'SubscribedContent-353694Enabled' -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name 'SubscribedContent-353696Enabled' -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Privacy : Online Speech Recognition : Disabled'

$Key = 'HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name HasAccepted -Value 1 -PropertyType DWord -Force | Out-Null

$Key = 'HKLM:\SOFTWARE\Policies\Microsoft\InputPersonalization\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name AllowInputPersonalization -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Privacy : Inking & Typing Personalization : Disabled'

$Key = 'HKCU:\SOFTWARE\Microsoft\InputPersonalization\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name RestrictImplicitInkCollection -Value 1 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Key -Name RestrictImplicitTextCollection -Value 1 -PropertyType DWord -Force | Out-Null

#

$Key = 'HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name HarvestContacts -Value 0 -PropertyType DWord -Force | Out-Null

#

$Key = 'HKCU:\SOFTWARE\Microsoft\Personalization\Settings\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name AcceptedPrivacyPolicy -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Privacy : Diagnostic & feedback : Send only required diagnostic data to Microsoft : Enabled'

$Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name ShowedToastAtLevel -Value 1 -PropertyType DWord -Force | Out-Null

#

$Keys = @(
    'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection\',
    'HKCU:\SOFTWARE\Policies\Microsoft\Windows\DataCollection\'
)
$Keys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null
New-ItemProperty -Path $Keys -Name AllowTelemetry -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Privacy : Diagnostic & feedback : Improve inking and typing recognition : Disabled'

$Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\TextInput\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name AllowLinguisticDataCollection -Value 0 -PropertyType DWord -Force | Out-Null

$Key = 'HKCU:\SOFTWARE\Microsoft\Input\TIPC\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name Enabled -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Privacy : Diagnostic & feedback : Tailored experiences with diagnostic data : Disabled'

$Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name TailoredExperiencesWithDiagnosticDataEnabled -Value 0 -PropertyType DWord -Force | Out-Null

#

$Key = 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name DisableTailoredExperiencesWithDiagnosticData -Value 1 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Privacy : Diagnostic & feedback : View diagnostic data : Disabled'

$Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\EventTranscriptKey\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name EnableEventTranscript -Value 0 -PropertyType DWord -Force | Out-Null

#

$Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name DisableDiagnosticDataViewer -Value 1 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Privacy : Diagnostic & feedback : Windows Feedback Frequency : Never'
$Key = 'HKCU:\SOFTWARE\Microsoft\Siuf\Rules\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name NumberOfSIUFInPeriod -Value 0 -PropertyType DWord -Force | Out-Null
Remove-ItemProperty -Path $Key -Name PeriodInNanoSeconds -Force -ErrorAction SilentlyContinue

Write-Host 'Privacy : Scheduled Tasks : \Microsoft\Windows\Feedback\Siuf\* : Disabled'
Get-ScheduledTask -TaskPath '\Microsoft\Windows\Feedback\Siuf\' | Disable-ScheduledTask | Out-Null

#-------------------------------------------------------------------------------

$Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null

Write-Host 'Privacy : OS Policies : Allow publishing of User Activities : Disabled'
New-ItemProperty -Path $Key -Name PublishUserActivities -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'Privacy : OS Policies : Allow upload of User Activities : Disabled'
New-ItemProperty -Path $Key -Name UploadUserActivities -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'Privacy : OS Policies : Allow Clipboard synchronization across devices : Disabled'
New-ItemProperty -Path $Key -Name AllowCrossDeviceClipboard -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host 'Privacy : OS Policies : Allow Clipboard History : Disabled'
New-ItemProperty -Path $Key -Name AllowClipboardHistory -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Privacy : App-V Policies : Microsoft Customer Experience Improvement Program (CEIP) : Enabled'
$Key = 'HKLM:\SOFTWARE\Policies\Microsoft\AppV\CEIP\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name CEIPEnable -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Privacy : Internet Communication Policies : Turn off Windows Customer Experience Improvement Program : Enabled'
$Key = 'HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name CEIPEnable -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Privacy : Internet Communication Policies : Turn off Help Experience Improvement Program : Enabled'
$Key = 'HKCU:\SOFTWARE\Policies\Microsoft\Assistance\Client\1.0\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name NoExplicitFeedback -Value 1 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Privacy : Internet Communication Policies : Turn off the Windows Messenger Customer Experience Improvement Program : Enabled'
$Keys = @(
    'HKLM:\SOFTWARE\Policies\Microsoft\Messenger\Client\',
    'HKCU:\SOFTWARE\Policies\Microsoft\Messenger\Client\'
)
$Keys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null
New-ItemProperty -Path $Keys -Name CEIP -Value 2 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Privacy : Scheduled Tasks : \Microsoft\Windows\Application Experience\* : Disabled'
Get-ScheduledTask -TaskPath '\Microsoft\Windows\Application Experience\' -TaskName 'MareBackup' | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskPath '\Microsoft\Windows\Application Experience\' -TaskName 'Microsoft Compatibility Appraiser' | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskPath '\Microsoft\Windows\Application Experience\' -TaskName 'ProgramDataUpdater' | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskPath '\Microsoft\Windows\Application Experience\' -TaskName 'StartupAppTask' | Disable-ScheduledTask | Out-Null

Write-Host 'Privacy : Scheduled Tasks : \Microsoft\Windows\Customer Experience Improvement Program\* : Disabled'
Get-ScheduledTask -TaskPath '\Microsoft\Windows\Customer Experience Improvement Program\' | Disable-ScheduledTask | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Privacy : Service : Connected User Experiences and Telemetry : Disabled'
Set-Service -Name 'DiagTrack' -StartupType Disabled -Status Stopped -Force

Write-Host 'Privacy : Service : Microsoft (R) DiagnosticsHub Standard Collector Service : Disabled'
Set-Service -Name 'diagnosticshub.standardcollector.service' -StartupType Disabled -Status Stopped -Force

#-------------------------------------------------------------------------------

# $CurrentUserSid = Get-WmiObject -Class win32_computersystem |
# Select-Object -ExpandProperty Username |
# ForEach-Object { ([System.Security.Principal.NTAccount]$_).Translate([System.Security.Principal.SecurityIdentifier]).Value }

#-------------------------------------------------------------------------------

# Write-Host 'Privacy : Show account details such as my email on the sign-in screen : Disabled'
# $Key = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\SystemProtectedUserData\$CurrentUserSid\AnyoneRead\Logon\"
# (Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
# New-ItemProperty -Path $Key -Name ShowEmail -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

# Write-Host 'Privacy : Use my sign-in info to automatically finish setting up my device after an update or restart : Disabled'
# $Key = 'HKLM:HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\UserARSO\$CurrentUserSid\'
# (Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
# New-ItemProperty -Path $Key -Name OptOut -Value 0 -PropertyType DWord -Force | Out-Null
