Write-Host "=== Cameron's Installed Software Inventory ==="

# Collect installed software from both 32-bit and 64-bit registry paths
$paths = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
)

$softwareList = @()

foreach ($path in $paths) {
    if (Test-Path $path) {
        Get-ChildItem $path | ForEach-Object {
            $item = Get-ItemProperty $_.PsPath -ErrorAction SilentlyContinue

            if ($item.DisplayName) {
                $softwareList += [PSCustomObject]@{
                    Name        = $item.DisplayName
                    Version     = $item.DisplayVersion
                    Publisher   = $item.Publisher
                    InstallDate = $item.InstallDate
                    Location    = $item.InstallLocation
                    Uninstall   = $item.UninstallString
                    Suspicious  = if ($item.InstallLocation -match "AppData|Temp|Unknown|Random") {"YES"} else {"NO"}
                }
            }
        }
    }
}

Write-Host "`n[Installed Software]"
$softwareList | Sort-Object Name | Format-Table -AutoSize

Write-Host "`n=== Software Inventory Complete ==="
