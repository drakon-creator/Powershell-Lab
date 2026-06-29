Write-Host "=== Cameron's Advanced Startup Auditor + Suspicious Scanner ==="

# ---------------------------------------------------------
# Helper: Build Startup Item Object
# ---------------------------------------------------------
function New-StartupItem {
    param(
        $Name, $Path, $Source
    )

    $exists = Test-Path $Path
    $fileInfo = $null
    $hash = $null
    $company = "Unknown"
    $version = "Unknown"
    $size = "Unknown"
    $created = "Unknown"
    $signed = "Unknown"

    if ($exists) {
        try {
            $fileInfo = Get-Item $Path
            $hash = (Get-FileHash $Path -Algorithm SHA256).Hash
            $versionInfo = (Get-Item $Path).VersionInfo

            $company = $versionInfo.CompanyName
            $version = $versionInfo.FileVersion
            $size = "{0:N2} MB" -f ($fileInfo.Length / 1MB)
            $created = $fileInfo.CreationTime

            # Signature check
            $sig = Get-AuthenticodeSignature $Path
            $signed = if ($sig.Status -eq "Valid") {"Signed"} else {"Unsigned"}
        } catch {}
    }

    # Suspicious scoring
    $suspicious = "NO"
    if ($Path -match "temp|appdata|unknown|random|\.exe$" -or $signed -eq "Unsigned") {
        $suspicious = "YES"
    }

    return [PSCustomObject]@{
        Name        = $Name
        Path        = $Path
        Source      = $Source
        Exists      = $exists
        Company     = $company
        Version     = $version
        Size        = $size
        Created     = $created
        Signed      = $signed
        Hash        = $hash
        Suspicious  = $suspicious
    }
}

# ---------------------------------------------------------
# Collect Startup Items
# ---------------------------------------------------------
$startupItems = @()

# HKCU Run
try {
    $cu = Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    foreach ($p in $cu.PSObject.Properties) {
        $startupItems += New-StartupItem $p.Name $p.Value "HKCU Run"
    }
} catch {}

# HKLM Run
try {
    $lm = Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
    foreach ($p in $lm.PSObject.Properties) {
        $startupItems += New-StartupItem $p.Name $p.Value "HKLM Run"
    }
} catch {}

# Startup Folders
$folders = @(
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup",
    "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
)

foreach ($folder in $folders) {
    if (Test-Path $folder) {
        Get-ChildItem $folder | ForEach-Object {
            $startupItems += New-StartupItem $_.Name $_.FullName "Startup Folder"
        }
    }
}

# ---------------------------------------------------------
# Display Results
# ---------------------------------------------------------
Write-Host "`n[Startup Programs + Suspicious Scan]"
if ($startupItems.Count -eq 0) {
    Write-Host "No startup programs found. System is clean."
} else {
    $startupItems | Format-Table -AutoSize
}

Write-Host "`n=== Suspicious Scan Complete ==="
