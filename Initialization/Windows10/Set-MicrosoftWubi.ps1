$ErrorActionPreference = 'Stop'

if (-not ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\InputMethod\Settings\CHS') -and (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\CTF\TIP\{6A498709-E00B-4C45-A018-8F9E4081AE40}'))) {
    return
}

Write-Host 'Microsoft Wubi : Default mode : English'

if (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\InputMethod\Settings\CHS') {
    Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\InputMethod\Settings\CHS' -Name 'Default Mode' -Value 1 -Type DWord
}

Write-Host 'Microsoft Wubi : Compatibility mode : Enabled'
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\CTF\TIP\{6A498709-E00B-4C45-A018-8F9E4081AE40}' -Name DummyValue -Value 0 -Type DWord

if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Input\TSF\Tsf3Override\{6a498709-e00b-4c45-a018-8f9e4081ae40}')) {
    $null = New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Input\TSF\Tsf3Override\{6a498709-e00b-4c45-a018-8f9e4081ae40}' -Force
}

Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Input\TSF\Tsf3Override\{6a498709-e00b-4c45-a018-8f9e4081ae40}' -Name NoTsf3Override2 -Value 0 -Type DWord
