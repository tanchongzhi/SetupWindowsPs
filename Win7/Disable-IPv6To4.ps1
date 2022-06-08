$ErrorActionPreference = "Stop"

Write-Host "Reseting IPv6 Protocol..."
netsh interface ipv6 reset

Write-Host "Disabling IPv6 teredo interface..."
netsh interface teredo set state disable

Write-Host "Disabling IPv6 6to4 interface..."
netsh interface 6to4 set state disable

Write-Host "Disabling IPv6 isatap interface..."
netsh interface isatap set state disable
