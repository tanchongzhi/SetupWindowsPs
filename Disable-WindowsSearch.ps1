Write-Host 'Service : Windows Search : Disabled'
Stop-Service -Name WSearch -Force -ErrorAction SilentlyContinue
Set-Service -Name WSearch -Status Stopped -StartupType Disabled -ErrorAction SilentlyContinue

Write-Host 'Cleaning Windows Search Indexes...'
Remove-Item -Path "$env:ProgramData\Microsoft\Search\Data\*" -Recurse -Force -ErrorAction SilentlyContinue
