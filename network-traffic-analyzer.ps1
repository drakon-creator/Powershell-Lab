Write-Host "=== Cameron's Network Traffic Analyzer ==="

# Get active TCP connections
$connections = Get-NetTCPConnection | Sort-Object -Property OwningProcess

$report = @()

foreach ($c in $connections) {
    $proc = Get-Process -Id $c.OwningProcess -ErrorAction SilentlyContinue

    $name = if ($proc) { $proc.ProcessName } else { "Unknown" }
    $path = if ($proc) { $proc.Path } else { "Unknown" }
    $company = "Unknown"
    $signed = "Unknown"
    $suspicious = "NO"

    try {
        $versionInfo = (Get-Item $path).VersionInfo
        $company = $versionInfo.CompanyName

        $sig = Get-AuthenticodeSignature $path
        $signed = if ($sig.Status -eq "Valid") {"Signed"} else {"Unsigned"}
    } catch {}

    # Suspicious logic
    if ($signed -eq "Unsigned") { $suspicious = "YES" }
    if ($company -eq $null -or $company -eq "") { $suspicious = "YES" }
    if ($path -match "AppData|Temp|Downloads") { $suspicious = "YES" }
    if ($c.RemotePort -in 22, 23, 3389) { $suspicious = "YES" }  # SSH, Telnet, RDP
    if ($c.RemoteAddress -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$" -and $c.RemoteAddress -notmatch "^(10\.|192\.168|172\.(1[6-9]|2[0-9]|3[0-1]))") {
        $suspicious = "YES"  # Public IP
    }

    $report += [PSCustomObject]@{
        Process     = $name
        PID         = $c.OwningProcess
        LocalIP     = $c.LocalAddress
        LocalPort   = $c.LocalPort
        RemoteIP    = $c.RemoteAddress
        RemotePort  = $c.RemotePort
        State       = $c.State
        Company     = $company
        Signed      = $signed
        Suspicious  = $suspicious
    }
}

Write-Host "`n[Active Network Connections]"
$report | Format-Table -AutoSize

Write-Host "`n=== Network Traffic Analysis Complete ==="
