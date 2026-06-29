Write-Host "=== Cameron's Windows Defender Repair Tool ==="

# Stop Defender services
Write-Host "`n[Stopping Defender Services]"
$services = @(
    "WinDefend",
    "wscsvc",
    "SecurityHealthService"
)

foreach ($svc in $services) {
    Write-Host "Stopping: $svc"
    Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
}

# Start Defender services
Write-Host "`n[Starting Defender Services]"
foreach ($svc in $services) {
    Write-Host "Starting: $svc"
    Start-Service -Name $svc -ErrorAction SilentlyContinue
}

# Reset Windows Update components (helps Defender updates)
Write-Host "`n[Resetting Windows Update Components]"
Stop-Service wuauserv -Force -ErrorAction SilentlyContinue
Stop-Service bits -Force -ErrorAction SilentlyContinue

Remove-Item -Recurse -Force "C:\Windows\SoftwareDistribution\*" -ErrorAction SilentlyContinue

Start-Service wuauserv -ErrorAction SilentlyContinue
Start-Service bits -ErrorAction SilentlyContinue

# Re-register Defender DLLs
Write-Host "`n[Re-registering Defender Components]"
$defenderDLLs = @(
    "wuaueng.dll",
    "wucltui.dll",
    "wups.dll",
    "wups2.dll",
    "wuwebv.dll"
)

foreach ($dll in $defenderDLLs) {
    Write-Host "Registering: $dll"
    regsvr32.exe /s "C:\Windows\System32\$dll"
}

# Force Defender update
Write-Host "`n[Updating Defender Definitions]"
Update-MpSignature

# Check Defender status
Write-Host "`n[Defender Status]"
Get-MpComputerStatus | Select-Object AMServiceEnabled, AntispywareEnabled, AntivirusEnabled, RealTimeProtectionEnabled

Write-Host "`n=== Windows Defender Repair Complete ==="
