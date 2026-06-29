Write-Host "=== Cameron's Browser Extension Auditor ==="

# Browser extension directories
$paths = @(
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Extensions",
    "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Extensions",
    "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Extensions",
    "$env:LOCALAPPDATA\Opera Software\Opera Stable\Extensions"
)

$extensions = @()

foreach ($path in $paths) {
    if (Test-Path $path) {
        $browser = ($path -split "\\")[2]  # Extract browser name

        Get-ChildItem $path | ForEach-Object {
            $extId = $_.Name
            $versionFolder = Get-ChildItem $_.FullName | Sort-Object Name -Descending | Select-Object -First 1

            $manifestPath = Join-Path $versionFolder.FullName "manifest.json"

            $name = "Unknown"
            $version = $versionFolder.Name
            $permissions = "Unknown"
            $suspicious = "NO"

            if (Test-Path $manifestPath) {
                try {
                    $json = Get-Content $manifestPath -Raw | ConvertFrom-Json
                    $name = $json.name
                    $permissions = ($json.permissions -join ", ")
                } catch {}
            }

            if ($permissions -match "tabs|webRequest|background|activeTab|storage|cookies") {
                $suspicious = "YES"
            }

            $extensions += [PSCustomObject]@{
                Browser     = $browser
                ExtensionID = $extId
                Name        = $name
                Version     = $version
                Permissions = $permissions
                Suspicious  = $suspicious
            }
        }
    }
}

Write-Host "`n[Browser Extensions Found]"
if ($extensions.Count -eq 0) {
    Write-Host "No browser extensions found."
} else {
    $extensions | Format-Table -AutoSize
}

Write-Host "`n=== Browser Extension Audit Complete ==="
