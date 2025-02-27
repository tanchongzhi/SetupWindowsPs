$ErrorActionPreference = 'Stop'

Write-Host 'Hibernate : Disabled'
$Key = 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\'
(Test-Path -Path $Key) -or (New-Item -Path $Key -Force) | Out-Null
New-ItemProperty -Path $Key -Name HibernateEnabled -Value 0 -PropertyType DWord -Force | Out-Null

#-------------------------------------------------------------------------------

Write-Host 'Hibernate : Deleting Hibernate File...'
$HibernateFilePath = "$env:SystemDrive\hiberfil.sys"

if (Test-Path -Path $HibernateFilePath -PathType Leaf) {
    Remove-Item -Path $HibernateFilePath -Force -ErrorAction SilentlyContinue
}
