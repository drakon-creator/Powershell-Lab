Write-Host "=== Cameron's Network Diagnostic Tool ==="

# Local IP Info
Write-Host "`n[Local IP Addresses]"
Get-NetIPAddress | Where-Object {$_.AddressFamily -eq "IPv4"} | ForEach-Object {
    Write-Host "Interface: $($_.InterfaceAlias) | IP: $($_.IPAddress)"
}

# DNS Servers
Write-Host "`n[DNS Servers]"
Get-DnsClientServerAddress | ForEach-Object {
    Write-Host "Interface: $($_.InterfaceAlias) | DNS: $($_.ServerAddresses)"
}

# Default Gateway
Write-Host "`n[Default Gateway]"
$gateway = Get-NetRoute -DestinationPrefix "0.0.0.0/0" | Select-Object -First 1
if ($gateway) {
    Write-Host "Gateway: $($gateway.NextHop)"
} else {
    Write-Host "No gateway detected."
}

# Ping Gateway
Write-Host "`n[Gateway Ping Test]"
if ($gateway) {
    $ping = Test-Connection -Count 2 -Quiet $gateway.NextHop
    if ($ping) {
        Write-Host "Gateway reachable."
    } else {
        Write-Host "Gateway NOT reachable."
    }
}

# Ping Google DNS
Write-Host "`n[Internet Connectivity Test]"
$internet = Test-Connection -Count 2 -Quiet 8.8.8.8
if ($internet) {
    Write-Host "Internet reachable."
} else {
    Write-Host "Internet NOT reachable."
}

# Public IP
Write-Host "`n[Public IP]"
try {
    $public = Invoke-RestMethod -Uri "https://api.ipify.org"
    Write-Host "Public IP: $public"
} catch {
    Write-Host "Unable to retrieve public IP."
}

# Adapter Status
Write-Host "`n[Network Adapter Status]"
Get-NetAdapter | ForEach-Object {
    Write-Host "$($_.Name) | Status: $($_.Status) | MAC: $($_.MacAddress)"
}

Write-Host "`n=== Network Diagnostic Complete ==="
