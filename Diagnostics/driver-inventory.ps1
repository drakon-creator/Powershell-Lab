Write-Host "=== Cameron's Driver Inventory & Health Checker ==="

$drivers = Get-WmiObject Win32_PnPSignedDriver

$report = @()

foreach ($d in $drivers) {

    $signed = if ($d.IsSigned) {"Signed"} else {"Unsigned"}
    $suspicious = "NO"

    # Suspicious logic
    if ($signed -eq "Unsigned") { $suspicious = "YES" }
    if ($d.DriverProviderName -match "Unknown|None") { $suspicious = "YES" }
    if ($d.DriverDate -lt (Get-Date).AddYears(-10)) { $suspicious = "YES" }  # Very old driver
    if ($d.InfName -match "temp|random|appdata") { $suspicious = "YES" }

    $report += [PSCustomObject]@{
        DeviceName   = $d.DeviceName
        Driver       = $d.DriverName
        Provider     = $d.DriverProviderName
        Version      = $d.DriverVersion
        Date         = $d.DriverDate
        Signed       = $signed
        INF          = $d.InfName
        Path         = $d.DriverPath
        Suspicious   = $suspicious
    }
}

Write-Host "`n[Driver Inventory]"
$report | Sort-Object DeviceName | Format-Table -AutoSize

Write-Host "`n=== Driver Inventory Complete ==="
