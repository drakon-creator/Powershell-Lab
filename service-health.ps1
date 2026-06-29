Write-Host "=== Cameron's Windows Service Health Checker ==="

# Collect all services
$services = Get-Service | Sort-Object DisplayName

$serviceReport = @()

foreach ($svc in $services) {
    $status = $svc.Status
    $startType = (Get-CimInstance Win32_Service -Filter "Name='$($svc.Name)'").StartMode
    $process = Get-Process -Name $svc.Name -ErrorAction SilentlyContinue

    $cpu = if ($process) { "{0:N2}%" -f ($process.CPU) } else { "N/A" }
    $mem = if ($process) { "{0:N2} MB" -f ($process.WorkingSet / 1MB) } else { "N/A" }

    # Suspicious detection
    $suspicious = "NO"
    if ($startType -eq "Auto" -and $status -ne "Running") {
        $suspicious = "YES"
    }
    if ($svc.Name -match "unknown|temp|random") {
        $suspicious = "YES"
    }

    $serviceReport += [PSCustomObject]@{
        Name        = $svc.DisplayName
        ServiceName = $svc.Name
        Status      = $status
        StartType   = $startType
        CPU         = $cpu
        Memory      = $mem
        Suspicious  = $suspicious
    }
}

Write-Host "`n[Service Health Report]"
$serviceReport | Format-Table -AutoSize

Write-Host "`n=== Service Health Check Complete ==="
