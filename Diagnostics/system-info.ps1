Write-Host "=== Cameron's System Info Tool ==="

# Basic System Info
Write-Host "`n[System Information]"
Write-Host "Computer Name: $env:COMPUTERNAME"
Write-Host "User Name: $env:USERNAME"
Write-Host "OS Version: $(Get-CimInstance Win32_OperatingSystem).Caption"
Write-Host "OS Build: $(Get-CimInstance Win32_OperatingSystem).BuildNumber"

# CPU
Write-Host "`n[CPU]"
$cpu = Get-CimInstance Win32_Processor
Write-Host "Name: $($cpu.Name)"
Write-Host "Cores: $($cpu.NumberOfCores)"
Write-Host "Logical Processors: $($cpu.NumberOfLogicalProcessors)"

# RAM
Write-Host "`n[Memory]"
$ram = Get-CimInstance Win32_ComputerSystem
Write-Host "Total RAM (GB): {0:N2}" -f ($ram.TotalPhysicalMemory / 1GB)

# Disk Info
Write-Host "`n[Disk Drives]"
Get-CimInstance Win32_LogicalDisk | ForEach-Object {
    Write-Host "Drive: $($_.DeviceID) | Free: {0:N2} GB | Total: {1:N2} GB" -f ($_.FreeSpace/1GB), ($_.Size/1GB)
}

# Network Info
Write-Host "`n[Network]"
Get-NetIPAddress | Where-Object {$_.AddressFamily -eq "IPv4"} | ForEach-Object {
    Write-Host "Interface: $($_.InterfaceAlias) | IP: $($_.IPAddress)"
}

Write-Host "`n=== End of Report ==="
