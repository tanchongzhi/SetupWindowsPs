$ErrorActionPreference = 'Stop'

Write-Host "Setting up automatically Administrator logon for user: $username"

$username = $env:USERNAME
$encryptedPassword = Read-Host -Prompt 'Password' -AsSecureString
$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($encryptedPassword)
$password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)

$Key = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\'
New-ItemProperty -Path $Key -Name AutoAdminLogon -Value 1 -PropertyType String -Force | Out-Null
New-ItemProperty -Path $Key -Name DefaultUserName -Value $username -PropertyType String -Force | Out-Null
New-ItemProperty -Path $Key -Name DefaultPassword -Value $password -PropertyType String -Force | Out-Null
