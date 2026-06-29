Write-Host "=== Cameron's Startup Program Auditor ==="

# Collect startup items from Registry + Startup Folders
$startupItems = @()

# Registry: Current User
$startupItems += Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -ErrorAction SilentlyContinue |
    Select-Object @{Name="Name";Expression={$_.PSChildName}}, @{Name="Path";Expression={$_."(Default)"}}, @{Name="Source";Expression={"HKCU Run"}}

# Registry: Local Machine
$startupItems += Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run" -ErrorAction SilentlyContinue |
    Select-Object @{Name="Name";Expression={$_.PSChildName}}, @{Name="Path";Expression={$_."(Default)"}}, @{Name="Source";Expression={"HKLM Run"}}

# Startup Folder (User)
$userStartup = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
if (Test-Path $userStartup) {
    Get-ChildItem $userStartup | ForEach-Object {
        $startupItems += [PSCustomObject]@{
            Name   = $_.Name
            Path   = $_.FullName
            Source = "User Startup Folder"
        }
    }
}

# Startup Folder (All Users)
$allStartup = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
if (Test-Path $allStartup) {
    Get-ChildItem $allStartup | ForEach-Object {
        $startupItems += [PSCustomObject]@{
            Name   = $_.Name
            Path   = $_.FullName
            Source = "All Users Startup Folder"
        }
    }
}

# Display results
Write-Host "`n[Startup Programs Found]"
$startupItems | Format-Table -AutoSize

Write-Host "`n=== Startup Audit Complete ==="
