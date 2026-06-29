Write-Host "=== Cameron's Windows Update Health Checker ==="

# Check Windows Update service
$wuauserv = Get-Service wuauserv -ErrorAction SilentlyContinue

Write-Host "`n[Windows Update Service]"
$wuauserv | Select-Object Name, Status, StartType | Format-Table -AutoSize

# Get update history
Write-Host "`n[Recent Update History]"
$history = Get-WinEvent -LogName "Microsoft-Windows-WindowsUpdateClient/Operational" -ErrorAction SilentlyContinue |
           Select-Object TimeCreated, Id, LevelDisplayName, Message |
           Sort-Object TimeCreated -Descending |
           Select-Object -First 20

$history | Format-Table -AutoSize

# Failed updates
Write-Host "`n[Failed Updates]"
$failed = $history | Where-Object { $_.LevelDisplayName -eq "Error" -or $_.Message -match "failed" }
$failed | Format-Table -AutoSize

# Pending updates
Write-Host "`n[Pending Updates]"
$pending = Get-WindowsUpdate -ErrorAction SilentlyContinue
$pending | Format-Table -AutoSize

# Servicing stack check
Write-Host "`n[Servicing Stack Health]"
$ssu = Get-WindowsPackage -Online | Where-Object { $_.PackageName -match "ServicingStack" }
$ssu | Select-Object PackageName, InstallTime, PackageState | Format-Table -AutoSize

Write-Host "`n=== Windows Update Health Check Complete ==="
