Write-Host "=== Cameron's Windows Cleanup Tool ==="

# Clear Windows Temp
Write-Host "`n[Temp Files]"
$paths = @(
    "$env:TEMP\*",
    "C:\Windows\Temp\*",
    "$env:LOCALAPPDATA\Temp\*"
)

foreach ($p in $paths) {
    if (Test-Path $p) {
        Write-Host "Cleaning: $p"
        Remove-Item $p -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# Clear Prefetch
Write-Host "`n[Prefetch]"
if (Test-Path "C:\Windows\Prefetch") {
    Remove-Item "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Prefetch cleaned."
}

# Clear Windows Update leftover downloads
Write-Host "`n[Windows Update Cache]"
if (Test-Path "C:\Windows\SoftwareDistribution\Download") {
    Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Windows Update cache cleaned."
}

# Clear browser caches (Edge + Chrome)
Write-Host "`n[Browser Cache]"
$browserPaths = @(
    "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache\*",
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*"
)

foreach ($bp in $browserPaths) {
    if (Test-Path $bp) {
        Write-Host "Cleaning browser cache: $bp"
        Remove-Item $bp -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# Clear log files
Write-Host "`n[Log Files]"
$logPaths = @(
    "C:\Windows\Logs\*",
    "$env:LOCALAPPDATA\Microsoft\Windows\Logs\*"
)

foreach ($lp in $logPaths) {
    if (Test-Path $lp) {
        Write-Host "Cleaning logs: $lp"
        Remove-Item $lp -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Write-Host "`n=== Cleanup Complete ==="
