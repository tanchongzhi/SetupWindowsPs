$ErrorActionPreference = "Stop"

Write-Host "Privacy : Let apps using advertising ID to make ads more interesting to you : Disabled"
$Key = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name Enabled -Value 0 -PropertyType DWord -Force
Remove-ItemProperty -Path $Key -Name Id -Force -ErrorAction SilentlyContinue

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "Privacy : Let websites provide locally relevant content by accessing my language list : Disabled"
$Key = "HKCU:\SOFTWARE\Microsoft\Internet Explorer\International\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)
Remove-ItemProperty -Path $Key -Name AcceptLanguage -Force -ErrorAction SilentlyContinue

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "Privacy : Show me suggested content in the Settings app : Disabled"
$Key = "HKCU:HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name "SubscribedContent-338393Enabled" -Value 0 -PropertyType DWord -Force
$null = New-ItemProperty -Path $Key -Name "SubscribedContent-353694Enabled" -Value 0 -PropertyType DWord -Force
$null = New-ItemProperty -Path $Key -Name "SubscribedContent-353696Enabled" -Value 0 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

$Key = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)

Write-Host "Privacy : Allow publishing of User Activities : Disabled"
$null = New-ItemProperty -Path $Key -Name PublishUserActivities -Value 0 -PropertyType DWord -Force

Write-Host "Privacy : Allow upload of User Activities : Disabled"
$null = New-ItemProperty -Path $Key -Name UploadUserActivities -Value 0 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "Privacy : Scheduled Tasks: \Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser : Disabled"
$null = Disable-ScheduledTask -TaskPath "\Microsoft\Windows\Application Experience\" -TaskName "Microsoft Compatibility Appraiser"

Write-Host "Privacy : Scheduled Tasks: \Microsoft\Windows\Customer Experience Improvement Program\* : Disabled"
$null = Get-ScheduledTask -TaskPath "\Microsoft\Windows\Customer Experience Improvement Program\" | Disable-ScheduledTask

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "Privacy : Windows Feedback Frequency : Never"
$Key = "HKCU:\SOFTWARE\Microsoft\Siuf\Rules\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name NumberOfSIUFInPeriod -Value 0 -PropertyType DWord -Force
Remove-ItemProperty -Path $Key -Name PeriodInNanoSeconds -Force -ErrorAction SilentlyContinue

Write-Host "Privacy : Scheduled Tasks: \Microsoft\Windows\Feedback\Siuf\* : Disabled"
$null = Get-ScheduledTask -TaskPath "\Microsoft\Windows\Feedback\Siuf\" | Disable-ScheduledTask

#-----------------------------------------------------------------------------------------------------------------------

# $CurrentUserSid = Get-WmiObject -Class win32_computersystem |
# Select-Object -ExpandProperty Username |
# ForEach-Object { ([System.Security.Principal.NTAccount]$_).Translate([System.Security.Principal.SecurityIdentifier]).Value }

#-----------------------------------------------------------------------------------------------------------------------

# Write-Host "Privacy : Show account details such as my email on the sign-in screen : Disabled"
# $Key = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\SystemProtectedUserData\$CurrentUserSid\AnyoneRead\Logon\"
# $null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)
# $null = New-ItemProperty -Path $Key -Name ShowEmail -Value 0 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

# Write-Host "Privacy : Use my sign-in info to automatically finish setting up my device after an update or restart : Disabled"
# $Key = "HKLM:HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\UserARSO\$CurrentUserSid\"
# $null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)
# $null = New-ItemProperty -Path $Key -Name OptOut -Value 0 -PropertyType DWord -Force
