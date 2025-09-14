$ErrorActionPreference = 'Stop'

$policyKeys = @(
    'HKLM:\Software\Policies\Microsoft\AppV\CEIP',
    'HKLM:\Software\Policies\Microsoft\InputPersonalization',
    'HKLM:\Software\Policies\Microsoft\Windows\DataCollection',
    'HKCU:\Software\Policies\Microsoft\Windows\DataCollection',
    'HKCU:\Software\Policies\Microsoft\Windows\CloudContent',
    'HKLM:\Software\Policies\Microsoft\Windows\System',
    'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\TextInput',
    'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
)
$policyKeys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

#

Write-Host 'Privacy Policy : App-V : Microsoft Customer Experience Improvement Program (CEIP) : Enabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\AppV\CEIP' -Name CEIPEnable -Value 0 -Type DWord

Write-Host 'Privacy Policy : Online Speech Recognition : Disabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\InputPersonalization' -Name AllowInputPersonalization -Value 0 -Type DWord

Write-Host 'Privacy Policy : Diagnostic & feedback : Send only required diagnostic data to Microsoft : Enabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection' -Name AllowTelemetry -Value 0 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Windows\DataCollection' -Name AllowTelemetry -Value 0 -Type DWord

Write-Host 'Privacy Policy : Diagnostic & feedback : View diagnostic data : Disabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection' -Name DisableDiagnosticDataViewer -Value 1 -Type DWord

Write-Host 'Privacy Policy : Diagnostic & feedback : Improve inking and typing recognition : Disabled'
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\TextInput' -Name AllowLinguisticDataCollection -Value 0 -Type DWord

Write-Host 'Privacy Policy : Diagnostic & feedback : Tailored experiences with diagnostic data : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Windows\CloudContent' -Name DisableTailoredExperiencesWithDiagnosticData -Value 1 -Type DWord

Write-Host 'Privacy Policy : Allow publishing of User Activities : Disabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name PublishUserActivities -Value 0 -Type DWord

Write-Host 'Privacy Policy : Allow upload of User Activities : Disabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name UploadUserActivities -Value 0 -Type DWord

Write-Host 'Privacy Policy : Allow Clipboard synchronization across devices : Disabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name AllowCrossDeviceClipboard -Value 0 -Type DWord

Write-Host 'Privacy Policy : Allow Clipboard History : Disabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name AllowClipboardHistory -Value 0 -Type DWord

Write-Host 'Privacy Policy : Block user from showing account details on sign-in : Enabled'
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name BlockUserFromShowingAccountDetailsOnSignin -Value 1 -Type DWord

Write-Host 'Privacy Policy : Sign-in and lock last interactive user automatically after a restart : Enabled'
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name DisableAutomaticRestartSignOn -Value 0 -Type DWord
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name AutomaticRestartSignOnConfig -Value 1 -Type DWord

#-------------------------------------------------------------------------------

$settingKeys = @(
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack',
    'HKLM:\Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\EventTranscriptKey',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy',
    'HKCU:\Software\Microsoft\Internet Explorer\International',
    'HKCU:\Software\Microsoft\Input\TIPC',
    'HKCU:\Software\Microsoft\InputPersonalization',
    'HKCU:\Software\Microsoft\Personalization\Settings',
    'HKCU:\Software\Microsoft\Siuf\Rules',
    'HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy'
)
$settingKeys | ForEach-Object { (Test-Path -Path $_) -or (New-Item -Path $_ -Force) } | Out-Null

#

Write-Host 'Privacy : Let apps using advertising ID to make ads more interesting to you : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo' -Name Enabled -Value 0 -Type DWord
Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo' -Name Id -ErrorAction SilentlyContinue

Write-Host 'Privacy : Let Windows track app launches to improve Start and search results : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name Start_TrackProgs -Value 0 -Type DWord

Write-Host 'Privacy : Let websites provide locally relevant content by accessing my language list : Disabled'
Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\International' -Name AcceptLanguage -ErrorAction SilentlyContinue

Write-Host 'Privacy : Show me suggested content in the Settings app : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-310093Enabled' -Value 0 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-338388Enabled' -Value 0 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-338389Enabled' -Value 0 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-338393Enabled' -Value 0 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-353694Enabled' -Value 0 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-353696Enabled' -Value 0 -Type DWord

Write-Host 'Privacy : Online Speech Recognition : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy' -Name HasAccepted -Value 0 -Type DWord

Write-Host 'Privacy : Inking & Typing Personalization : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\InputPersonalization' -Name RestrictImplicitInkCollection -Value 1 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\InputPersonalization' -Name RestrictImplicitTextCollection -Value 1 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore' -Name HarvestContacts -Value 0 -Type DWord
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Personalization\Settings' -Name AcceptedPrivacyPolicy -Value 0 -Type DWord

Write-Host 'Privacy : Diagnostic & feedback : Send only required diagnostic data to Microsoft : Enabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack' -Name ShowedToastAtLevel -Value 1 -Type DWord

Write-Host 'Privacy : Diagnostic & feedback : View diagnostic data : Disabled'
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\EventTranscriptKey' -Name EnableEventTranscript -Value 0 -Type DWord

Write-Host 'Privacy : Diagnostic & feedback : Improve inking and typing recognition : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Input\TIPC' -Name Enabled -Value 0 -Type DWord

Write-Host 'Privacy : Diagnostic & feedback : Tailored experiences with diagnostic data : Disabled'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy' -Name TailoredExperiencesWithDiagnosticDataEnabled -Value 0 -Type DWord

Write-Host 'Privacy : Diagnostic & feedback : Windows Feedback Frequency : Never'
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Siuf\Rules' -Name NumberOfSIUFInPeriod -Value 0 -Type DWord
Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Siuf\Rules' -Name PeriodInNanoSeconds -ErrorAction SilentlyContinue

Write-Host 'Privacy : Scheduled Tasks : \Microsoft\Windows\Feedback\Siuf\* : Disabled'
$null = Get-ScheduledTask -TaskPath '\Microsoft\Windows\Feedback\Siuf\' | Disable-ScheduledTask

Write-Host 'Privacy : Scheduled Tasks : \Microsoft\Windows\Customer Experience Improvement Program\* : Disabled'
$null = Get-ScheduledTask -TaskPath '\Microsoft\Windows\Customer Experience Improvement Program\' | Disable-ScheduledTask

Write-Host 'Privacy : Service : Microsoft (R) DiagnosticsHub Standard Collector Service : Disabled'
Set-Service -Name 'diagnosticshub.standardcollector.service' -StartupType Disabled -Status Stopped
