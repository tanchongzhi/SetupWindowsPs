$ErrorActionPreference = 'Stop'

Write-Host 'Hibernate : Disabled'

try {
    powercfg -H OFF >$null 2>&1
} catch {}

Write-Host 'Hibernate : Deleting Hibernate File...'

$HibernateFilePath = "$env:SystemDrive\hiberfil.sys"

if (Test-Path -Path $HibernateFilePath -PathType Leaf) {
    Remove-Item -Path $HibernateFilePath -Force -ErrorAction SilentlyContinue
}
