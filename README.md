

# **🔥 Cameron’s Windows Diagnostic & Maintenance Toolkit**
A collection of PowerShell tools designed to audit, diagnose, repair, and maintain Windows systems — built for technicians, cybersecurity learners, and anyone who wants deep visibility into their machine.

This toolkit includes:

- System Information  
- Full Diagnostic Report  
- Cleanup Tool  
- Network Diagnostic Tool  
- Windows Defender Repair  
- Startup Program Auditor (Basic + Advanced + Suspicious Scanner)  
- Installed Software Inventory  
- Windows Service Health Checker  
- One‑Click Maintenance Tool  

Every script is lightweight, safe, and designed to run directly from GitHub using `Invoke-WebRequest`.

---

## **🚀 Quick Start**
Run any tool instantly using:

```
iwr https://raw.githubusercontent.com/drakon-creator/Powershell-Lab/main/<scriptname>.ps1 | iex
```

Example:

```
iwr https://raw.githubusercontent.com/drakon-creator/Powershell-Lab/main/system-info.ps1 | iex
```

---

## **🧰 Tools Included**

### **1. System Information Tool**
Collects CPU, RAM, disk, OS version, and network details.

### **2. Full Diagnostic Report**
Generates a complete text report on the Desktop with system, disk, memory, network, and security information.

### **3. Cleanup Tool**
Removes temp files, caches, logs, and other junk to improve performance.

### **4. Network Diagnostic Tool**
Shows IPs, adapters, DNS, gateway, connectivity, and network health.

### **5. Windows Defender Repair Tool**
Restores Defender services, re-registers components, and fixes common issues.

### **6. Startup Program Auditor**
- Basic version  
- Advanced version  
- Suspicious Scanner version  
Shows startup programs, scheduled tasks, auto-start services, and flags suspicious entries.

### **7. Installed Software Inventory**
Lists all installed programs, versions, publishers, install dates, and suspicious locations.

### **8. Windows Service Health Checker**
Shows service status, start type, CPU/memory usage, and flags failing or suspicious services.

### **9. One‑Click Maintenance Tool**
Runs cleanup, diagnostics, Defender repair, and full system report in one command.

---

## **📦 One‑Click Maintenance Command**

Run the entire toolkit automatically:

```
iwr https://raw.githubusercontent.com/drakon-creator/Powershell-Lab/main/one-click-maintenance.ps1 | iex
```

---

## **📁 Repository Structure**
```
Powershell-Lab/
│
├── system-info.ps1
├── full-diagnostic.ps1
├── cleanup-tool.ps1
├── network-diagnostic.ps1
├── defender-repair.ps1
├── startup-auditor.ps1
├── startup-auditor-advanced.ps1
├── startup-auditor-advanced-v2.ps1
├── installed-software.ps1
├── service-health.ps1
└── one-click-maintenance.ps1
```

---

## **🛠 Requirements**
- Windows 10 or 11  
- PowerShell 5.1+  
- Internet connection (for GitHub raw execution)

---

## **⚠️ Disclaimer**
These tools are designed for **diagnostics and maintenance only**.  
They do not modify critical system components beyond safe cleanup and Defender repair.

---

## **📜 License**
MIT License — free to use, modify, and share.

---

## **👤 Author**
**Cameron (drakon-creator)**  
Windows tinkerer, cybersecurity learner, and builder of practical tools.

