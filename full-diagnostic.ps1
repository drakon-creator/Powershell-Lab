Write-Host "=== Cameron's Full Diagnostic Report Generator ==="

# Output file
$report = "$env:USERPROFILE\Desktop\System-Diagnostic-Report.txt"
Write-Host "Saving report to: $report"

# Start fresh
"=== Cameron's System Diagnostic Report ===`n" | Out-File $report

# System Info
"--- System Information ---" | Out-File $report -Append
$os = Get-CimInstance Win32_OperatingSystem
"Computer Name: $env:COMPUTERNAME" | Out-File $report -Append
"User Name: $env:USERNAME" | Out-File $report -Append
"OS Version: $($os.Caption)" | Out-File $report -Append
"OS Build: $($os.BuildNumber)`n" | Out-File $report -Append

# CPU
"--- CPU Information ---" | Out-File $report -Append
$cpu = Get-CimInstance Win32_Processor
"Name: $($cpu.Name)" | Out-File $report -Append
"Cores: $($cpu.NumberOfCores)" | Out-File $report -Append
"Logical Processors: $($cpu.NumberOfLogicalProcessors)`n" | Out-File $report -Append

# RAM
"--- Memory Information ---" | Out-File $report -Append
$ram = Get-CimInstance Win32_ComputerSystem
"Total RAM (GB): {0:N2}" -f ($ram.TotalPhysicalMemory / 1GB) | Out-File $report -Append
"`n" | Out-File $report -Append

# Disk Info
"--- Disk Information ---" | Out-File $report -Append
Get-CimInstance Win32_LogicalDisk | ForEach-Object {
    "Drive: $($_.DeviceID) | Free: {0:N2} GB | Total: {1:N2} GB" -f ($_.FreeSpace/1GB), ($_.Size/1GB) | Out-File $report -Append
}
"`n" | Out-File $report -Append

# Network Info
"--- Network Information ---" | Out-File $report -Append
Get-NetIPAddress | Where-Object {$_.AddressFamily -eq "IPv4"} | ForEach-Object {
    "Interface: $($_.InterfaceAlias) | IP: $($_.IPAddress)" | Out-File $report -Append
}
"`n" | Out-File $report -Append

# DNS
"--- DNS Servers ---" | Out-File $report -Append
Get-DnsClientServerAddress | ForEach-Object {
    "Interface: $($_.InterfaceAlias) | DNS: $($_.ServerAddresses)" | Out-File $report -Append
}
"`n" | Out-File $report -Append

# Gateway
"--- Default Gateway ---" | Out-File $report -Append
$gateway = Get-NetRoute -DestinationPrefix "0.0.0.0/0" | Select-Object -First 1
if ($gateway) {
    "Gateway: $($gateway.NextHop)" | Out-File $report -Append
} else {
    "No gateway detected." | Out-File $report -Append
}
"`n" | Out-File $report -Append

# Connectivity Tests
"--- Connectivity Tests ---" | Out-File $report -Append
$gwPing = Test-Connection -Count 2 -Quiet $gateway.NextHop
"Gateway Reachable: $gwPing" | Out-File $report -Append

$internet = Test-Connection -Count 2 -Quiet 8.8.8.8
"Internet Reachable: $internet" | Out-File $report -Append
"`n" | Out-File $report -Append

# Public IP
"--- Public IP ---" | Out-File $report -Append
try {
    $public = Invoke-RestMethod -Uri "https://api.ipify.org"
    "Public IP: $public" | Out-File $report -Append
} catch {
    "Unable to retrieve public IP." | Out-File $report -Append
}
"`n" | Out-File $report -Append

# Defender Status
"--- Windows Defender Status ---" | Out-File $report -Append
Get-MpComputerStatus | Select-Object AMServiceEnabled, AntispywareEnabled, AntivirusEnabled, RealTimeProtectionEnabled | Out-File $report -Append
"`n" | Out-File $report -Append

"=== Diagnostic Complete ===" | Out-File $report -Append

Write-Host "`nReport generated successfully!"
Write-Host "Saved to: $report"
