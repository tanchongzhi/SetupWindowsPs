$ErrorActionPreference = 'Stop'

$Key = 'HKCU:\SOFTWARE\Microsoft\InputMethod\Settings\CHS\'

if (Test-Path -Path $Key) {
    Write-Host 'Microsoft Wubi : Default mode : English'
    New-ItemProperty -Path $Key -Name 'Default Mode' -Value 1 -PropertyType DWord -Force | Out-Null
}

#-------------------------------------------------------------------------------

$Key = 'HKCU:\SOFTWARE\Microsoft\Input\TSF\Tsf3Override\{6a498709-e00b-4c45-a018-8f9e4081ae40}\'

if (Test-Path -Path $Key) {
    Write-Host 'Microsoft Wubi : Compatibility mode : Enabled'
    New-ItemProperty -Path $Key -Name NoTsf3Override2 -Value 0 -PropertyType DWord -Force | Out-Null
}

$Key = 'HKCU:\SOFTWARE\Microsoft\CTF\TIP\{6A498709-E00B-4C45-A018-8F9E4081AE40}\'

if (Test-Path -Path $Key) {
    New-ItemProperty -Path $Key -Name DummyValue -Value 0 -PropertyType DWord -Force | Out-Null
}
