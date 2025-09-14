$ErrorActionPreference = 'Stop'

Write-Host 'Hibernate : Disabled'

try {
    powercfg /hibernate off >$null 2>&1
} catch {}

$HibernateFilePath = "$env:SystemDrive\hiberfil.sys"

if (Test-Path -Path $HibernateFilePath) {
    Write-Host 'Hibernate : Deleting Hibernate File...'
    Remove-Item -Path $HibernateFilePath -Force -ErrorAction SilentlyContinue
}
