$ErrorActionPreference = "Stop"

Write-Host "Setting up service "RPC Endpoint Mapper" start automatically..."
Set-Service -Name RpcEptMapper -Status Running -StartupType Automatic -ErrorAction SilentlyContinue

Write-Host "Setting up service "DCOM Server Process Launcher" start automatically..."
Set-Service -Name DcomLaunch -Status Running -StartupType Automatic -ErrorAction SilentlyContinue

Write-Host "Setting up service "Remote Procedure Call (RPC)r" start automatically..."
Set-Service -Name RpcSs -Status Running -StartupType Automatic -ErrorAction SilentlyContinue

Write-Host "Setting up service "Network Store Interface Service" start automatically..."
Set-Service -Name nsi -Status Running -StartupType Automatic -ErrorAction SilentlyContinue

Write-Host "Setting up service "Windows Management Instrumentation" start automatically..."
Set-Service -Name Winmgmt -Status Running -StartupType Automatic -ErrorAction SilentlyContinue

Write-Host "Setting up service "DHCP Client" start automatically..."
Set-Service -Name Dhcp -Status Running -StartupType Automatic -ErrorAction SilentlyContinue

Write-Host "Setting up service "WinHTTP Web Proxy Auto-Discovery Service" start automatically..."
Set-Service -Name WinHttpAutoProxySvc -Status Running -StartupType Automatic -ErrorAction SilentlyContinue

Write-Host "Setting up service "IP Helper" start automatically..."
Set-Service -Name iphlpsvc -Status Running -StartupType Automatic -ErrorAction SilentlyContinue

Write-Host "Reseting IPv6 Protocol..."
netsh interface ipv6 reset

Write-Host "Reseting IPv6 teredo interface state..."
netsh interface teredo set state type=default

Write-Host "Reseting IPv6 6to4 interface state..."
netsh interface 6to4 set state state=default

Write-Host "Reseting IPv6 isatap interface state..."
netsh interface isatap set state state=default

Write-Host "Setting up IPv6 teredo server: teredo-debian.remlab.net"
# win1807.ipv6.microsoft.com
# win1711.ipv6.microsoft.com
# win1710.ipv6.microsoft.com
# win10.ipv6.microsoft.com
# teredo-debian.remlab.net
# teredo.remlab.net
# teredo2.remlab.net
# teredo.trex.fi
# debian-miredo.progsoc.org
# teredo.iks-jena.de
netsh interface teredo set state servername=teredo-debian.remlab.net

Write-Host "Setting IPv6 teredo as enterprise client..."
netsh interface ipv6 set teredo type=enterpriseclient
netsh interface teredo set state type=enterpriseclient

Write-Host "Setting IPv6 teredo as enterprise client..."
netsh interface ipv6 set global randomizeidentifiers=disabled

Write-Host "Removing IPv6 loopback route..."
route delete ::/0

Write-Host "Setting IPv6 protocol prefix policies..."
netsh interface ipv6 set prefixpolicy prefix=2002::/16 precedence=30 label=1
netsh interface ipv6 set prefixpolicy prefix=2001::/32 precedence=5 label=1

Write-Host "Adding IPv6 loopback route..."

$interfaceStatesRaw = netsh interface show interface
$interfaceStates = $interfaceStatesRaw | ForEach-Object { $_.Trim() } | Where-Object { $_ }
$interfaceStates = $interfaceStates[2..$interfaceStates.Count]

$interfaceNames = @()

foreach ($line in $interfaceStates) {
    $fields = $line.Split(" ", 4, [System.StringSplitOptions]::RemoveEmptyEntries)
    $interfaceNames += $fields[3]
}

$interfaceStatesRaw

$name = Read-Host -Prompt "Enter interface name"
$name = $name.Trim()
$isValidName = $interfaceNames | Where-Object { $_ -eq $name }

if ($isValidName) {
    netsh interface ipv6 add route ::/0 $name
} else {
    Write-Host "Invalid interface name."
    Write-Host "You can run this command to add IPv6 route: netsh interface ipv6 add route ::/0 <INTERFACE NAME>"
}

$null = New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\services\Dnscache\Parameters\" -Name AddrConfigControl -Value 0 -PropertyType DWord -Force
$null = New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\services\TCPIP6\Parameters\" -Name DisabledComponents -Value 0 -PropertyType DWord -Force

Write-Host "Flushing DNS cache..."
ipconfig /flushdns

$printInfo = Read-Host -Prompt "Do you want to print network settings? [N/y]: "
$printInfo = $printInfo.Trim()

if (($printInfo -eq "y") -or ($printInfo -eq "yes")) {
    Write-Host "Showing network information..."
    Write-Host ""
    ipconfig /all
    netsh interface ipv6 show teredo
    netsh interface ipv6 show route
    netsh interface ipv6 show interface
    netsh interface ipv6 show prefixpolicies
    netsh interface ipv6 show address
    route print
}
