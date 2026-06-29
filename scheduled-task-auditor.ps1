Write-Host "=== Cameron's Scheduled Task Auditor ==="

$tasks = Get-ScheduledTask

$report = @()

foreach ($t in $tasks) {
    $action = $t.Actions | Select-Object -First 1
    $exec = $action.Execute
    $args = $action.Arguments
    $path = $exec

    $exists = Test-Path $path
    $signed = "Unknown"
    $company = "Unknown"
    $suspicious = "NO"

    if ($exists) {
        try {
            $versionInfo = (Get-Item $path).VersionInfo
            $company = $versionInfo.CompanyName

            $sig = Get-AuthenticodeSignature $path
            $signed = if ($sig.Status -eq "Valid") {"Signed"} else {"Unsigned"}
        } catch {}
    }

    # Suspicious logic
    if ($signed -eq "Unsigned") { $suspicious = "YES" }
    if ($company -eq $null -or $company -eq "") { $suspicious = "YES" }
    if ($path -match "AppData|Temp|Downloads") { $suspicious = "YES" }
    if ($exists -eq $false) { $suspicious = "YES" }
    if ($t.TaskName -match "update|helper|service|random|unknown") { $suspicious = "YES" }

    $report += [PSCustomObject]@{
        Name        = $t.TaskName
        Path        = $path
        Arguments   = $args
        Exists      = $exists
        Company     = $company
        Signed      = $signed
        Trigger     = ($t.Triggers | Select-Object -First 1).ToString()
        Suspicious  = $suspicious
    }
}

Write-Host "`n[Scheduled Task Audit]"
$report | Format-Table -AutoSize

Write-Host "`n=== Scheduled Task Audit Complete ==="
