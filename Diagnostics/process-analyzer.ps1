Write-Host "=== Cameron's Process Behavior Analyzer ==="

$processes = Get-Process | Sort-Object CPU -Descending

$report = @()

foreach ($p in $processes) {
    $path = "N/A"
    $company = "Unknown"
    $signed = "Unknown"
    $suspicious = "NO"

    try {
        $path = $p.Path
        $versionInfo = (Get-Item $path).VersionInfo
        $company = $versionInfo.CompanyName

        $sig = Get-AuthenticodeSignature $path
        $signed = if ($sig.Status -eq "Valid") {"Signed"} else {"Unsigned"}
    } catch {}

    # Suspicious logic
    if ($signed -eq "Unsigned") { $suspicious = "YES" }
    if ($company -eq $null -or $company -eq "") { $suspicious = "YES" }
    if ($path -match "AppData|Temp|Downloads") { $suspicious = "YES" }
    if ($p.CPU -gt 100) { $suspicious = "YES" }  # High CPU
    if ($p.WorkingSet -gt 500MB) { $suspicious = "YES" }  # High memory
    if ($p.ProcessName -match "random|unknown|temp") { $suspicious = "YES" }

    $report += [PSCustomObject]@{
        Name       = $p.ProcessName
        CPU        = "{0:N2}" -f $p.CPU
        MemoryMB   = "{0:N2}" -f ($p.WorkingSet / 1MB)
        Path       = $path
        Company    = $company
        Signed     = $signed
        Suspicious = $suspicious
    }
}

Write-Host "`n[Process Behavior Report]"
$report | Format-Table -AutoSize

Write-Host "`n=== Process Analysis Complete ==="
