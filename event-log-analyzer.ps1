Write-Host "=== Cameron's Windows Event Log Analyzer ==="

# Time window (last 48 hours)
$timeWindow = (Get-Date).AddHours(-48)

# Collect logs
$systemLogs = Get-WinEvent -LogName System -ErrorAction SilentlyContinue | Where-Object { $_.TimeCreated -gt $timeWindow }
$appLogs    = Get-WinEvent -LogName Application -ErrorAction SilentlyContinue | Where-Object { $_.TimeCreated -gt $timeWindow }
$secLogs    = Get-WinEvent -LogName Security -ErrorAction SilentlyContinue | Where-Object { $_.TimeCreated -gt $timeWindow }

# Filter important events
$critical = $systemLogs | Where-Object { $_.LevelDisplayName -eq "Critical" }
$errors   = $systemLogs | Where-Object { $_.LevelDisplayName -eq "Error" }
$warnings = $systemLogs | Where-Object { $_.LevelDisplayName -eq "Warning" }

$appErrors = $appLogs | Where-Object { $_.LevelDisplayName -eq "Error" }
$appCrashes = $appLogs | Where-Object { $_.Id -eq 1000 }  # Application crash events

$secFailures = $secLogs | Where-Object { $_.Id -in 4625, 4647, 4673 }  # Failed logons, privilege issues

# Output
Write-Host "`n[System Critical Events]"
$critical | Select-Object TimeCreated, Id, ProviderName, Message | Format-Table -AutoSize

Write-Host "`n[System Errors]"
$errors | Select-Object TimeCreated, Id, ProviderName, Message | Format-Table -AutoSize

Write-Host "`n[System Warnings]"
$warnings | Select-Object TimeCreated, Id, ProviderName, Message | Format-Table -AutoSize

Write-Host "`n[Application Errors]"
$appErrors | Select-Object TimeCreated, Id, ProviderName, Message | Format-Table -AutoSize

Write-Host "`n[Application Crashes]"
$appCrashes | Select-Object TimeCreated, Id, ProviderName, Message | Format-Table -AutoSize

Write-Host "`n[Security Failures]"
$secFailures | Select-Object TimeCreated, Id, Message | Format-Table -AutoSize

Write-Host "`n=== Event Log Analysis Complete ==="
