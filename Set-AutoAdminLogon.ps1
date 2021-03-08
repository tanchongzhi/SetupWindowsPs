$ErrorActionPreference = 'Stop'

$userName = $env:USERNAME

$encryptedPassword = Read-Host -Prompt 'Password' -AsSecureString
$bstr = [System.Runtime.InteropServices.marshal]::SecureStringToBSTR($encryptedPassword);
$password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr);
[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr);

Write-Host "Setting up automatically Administrator logon for user: $userName"

$Key = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
$null = New-ItemProperty -Path $Key -Name AutoAdminLogon -Value 1 -PropertyType String -Force
$null = New-ItemProperty -Path $Key -Name DefaultUserName -Value $userName -PropertyType String -Force
$null = New-ItemProperty -Path $Key -Name DefaultPassword -Value $password -PropertyType String -Force
