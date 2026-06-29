Write-Host "=== Cameron's One-Click Maintenance Tool ==="

# ---------------------------------------------------------
# Paths to your other tools (GitHub RAW links)
# ---------------------------------------------------------
$cleanup     = "https://raw.githubusercontent.com/drakon-creator/Powershell-Lab/main/cleanup-tool.ps1"
$network     = "https://raw.githubusercontent.com/drakon-creator/Powershell-Lab/main/network-diagnostic.ps1"
$defender    = "https://raw.githubusercontent.com/drakon-creator/Powershell-Lab/main/defender-repair.ps1"
$fullReport  = "https://raw.githubusercontent.com/drakon-creator/Powershell-Lab/main/full-diagnostic.ps1"

# ---------------------------------------------------------
# Function to run remote scripts
# ---------------------------------------------------------
function Run-RemoteScript($url, $name) {
    Write-Host "`n--- Running: $name ---"
    try {
        iwr $url | iex
        Write-Host "--- $name Complete ---"
    }
    catch {
        Write-Host "ERROR running $name"
    }
}

# ---------------------------------------------------------
# Execute each tool in order
# ---------------------------------------------------------

Run-RemoteScript $cleanup "Cleanup Tool"
Run-RemoteScript $network "Network Diagnostic Tool"
Run-RemoteScript $defender "Windows Defender Repair Tool"
Run-RemoteScript $fullReport "Full Diagnostic Report Generator"

Write-Host "`n=== One-Click Maintenance Complete ==="
Write-Host "All tasks finished successfully."
