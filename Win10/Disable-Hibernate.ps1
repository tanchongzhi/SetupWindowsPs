$ErrorActionPreference = "Stop"

Write-Host "Hibernate : Disabled"
$Key = "HKLM:\SYSTEM\CurrentControlSet\Control\Power\"
$null = (Test-Path -Path $Key) -or (New-Item -Path $Key -Force)
$null = New-ItemProperty -Path $Key -Name HibernateEnabled -Value 0 -PropertyType DWord -Force

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "Hibernate : Deleting Hibernate File..."
$HibernateFilePath = "$env:SystemDrive\hiberfil.sys"

if (Test-Path -Path $HibernateFilePath -PathType Leaf) {
    Remove-Item -Path $HibernateFilePath -Force -ErrorAction SilentlyContinue
}
