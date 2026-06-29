Write-Host "=== Cameron's Advanced Startup Auditor ==="

# ---------------------------------------------------------
# Collect Startup Items (Registry + Folders)
# ---------------------------------------------------------
$startupItems = @()

function Add-StartupItem($name, $path, $source) {
    $startupItems += [PSCustomObject]@{
        Name   = $name
        Path   = $path
        Source = $source
        Suspicious = if ($path -match "temp|appdata|\.exe$|unknown|random") {"YES"} else {"NO"}
    }
}

# HKCU Run
try {
    $cu = Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    foreach ($p in $cu.PSObject.Properties) {
        Add-StartupItem $p.Name $p.Value "HKCU Run"
    }
} catch {}

# HKLM Run
try {
    $lm = Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
    foreach ($p in $lm.PSObject.Properties) {
        Add-StartupItem $p.Name $p.Value "HKLM Run"
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
            Add-StartupItem $_.Name $_.FullName "Startup Folder"
        }
    }
}

# ---------------------------------------------------------
# Scheduled Tasks (Boot / Logon)
# ---------------------------------------------------------
Write-Host "`n[Scheduled Tasks]"
$tasks = Get-ScheduledTask | Where-Object {
    $_.Triggers -match "AtLogon" -or $_.Triggers -match "Boot"
}

$taskList = $tasks | Select-Object TaskName, TaskPath, State
$taskList | Format-Table -AutoSize

# ---------------------------------------------------------
# Auto-Start Services
# ---------------------------------------------------------
Write-Host "`n[Auto-Start Services]"
$services = Get-Service | Where-Object {$_.StartType -eq "Automatic"}
$services | Select-Object Name, DisplayName, Status | Format-Table -AutoSize

# ---------------------------------------------------------
# Display Startup Items
# ---------------------------------------------------------
Write-Host "`n[Startup Programs]"
if ($startupItems.Count -eq 0) {
    Write-Host "No startup programs found. System is clean."
} else {
    $startupItems | Format-Table -AutoSize
}

# ---------------------------------------------------------
# Disable Option
# ---------------------------------------------------------
Write-Host "`nWould you like to disable a startup item? (y/n)"
$choice = Read-Host

if ($choice -eq "y") {
    Write-Host "Enter the EXACT name of the startup item:"
    $item = Read-Host

    $target = $startupItems | Where-Object {$_.Name -eq $item}

    if ($target) {
        if ($target.Source -eq "HKCU Run") {
            Remove-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name $item
        }
        elseif ($target.Source -eq "HKLM Run") {
            Remove-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run" -Name $item
        }
        Write-Host "Startup item disabled."
    } else {
        Write-Host "Item not found."
    }
}

Write-Host "`n=== Advanced Startup Audit Complete ==="
