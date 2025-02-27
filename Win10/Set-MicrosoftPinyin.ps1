$ErrorActionPreference = 'Stop'

$Key = 'HKCU:\SOFTWARE\Microsoft\InputMethod\Settings\CHS\'

if (Test-Path -Path $Key) {
    Write-Host 'Microsoft Pinyin : Default mode : English'
    New-ItemProperty -Path $Key -Name 'Default Mode' -Value 1 -PropertyType DWord -Force | Out-Null

    Write-Host 'Microsoft Pinyin : Cloud Candidate : Disabled'
    New-ItemProperty -Path $Key -Name 'Enable Cloud Candidate' -Value 0 -PropertyType DWord -Force | Out-Null

    Write-Host 'Microsoft Pinyin : Live Sticker : Disabled'
    New-ItemProperty -Path $Key -Name EnableLiveSticker -Value 0 -PropertyType DWord -Force | Out-Null
}

#-------------------------------------------------------------------------------

$Key = 'HKCU:\SOFTWARE\Microsoft\Input\TSF\Tsf3Override\{81d4e9c9-1d3b-41bc-9e6c-4b40bf79e35e}\'

if (Test-Path -Path $Key) {
    Write-Host 'Microsoft Pinyin : Compatibility mode : Enabled'
    New-ItemProperty -Path $Key -Name NoTsf3Override2 -Value 0 -PropertyType DWord -Force | Out-Null
}

$Key = 'HKCU:\SOFTWARE\Microsoft\CTF\TIP\{81D4E9C9-1D3B-41BC-9E6C-4B40BF79E35E}\'

if (Test-Path -Path $Key) {
    New-ItemProperty -Path $Key -Name DummyValue -Value 0 -PropertyType DWord -Force | Out-Null
}
