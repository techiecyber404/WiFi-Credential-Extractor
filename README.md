# 🔐 WiFi Credential Extractor

![PowerShell](https://img.shields.io/badge/PowerShell-v5.1+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

> **⚠️ Legal Notice**: Only use on networks you own or have explicit permission to test.

## 📥 Installation
```powershell
# Download directly
irm https://raw.githubusercontent.com/YOURUSERNAME/WiFi-Credential-Extractor/main/Get-WiFiCredentials.ps1 -OutFile wifi.ps1
```

## 🚀 Basic Usage
```powershell
# Run with default options (admin PowerShell required)
.\Get-WiFiCredentials.ps1 -LocalOnly
```

## ⚙️ Parameters
| Parameter       | Description                          |
|-----------------|--------------------------------------|
| `-LocalOnly`    | Disables cloud upload                |
| `-ShowPasswords`| Displays passwords in console        |
| `-OutputPath`   | Custom save location                 |

## 🛡️ Execution Bypass
If blocked by policies:
```powershell
# Method 1: Temporary bypass
Set-ExecutionPolicy Bypass -Scope Process -Force

# Method 2: Direct execution
powershell.exe -ExecutionPolicy Bypass -File .\wifi.ps1
```

## 📜 License
MIT © Venkatesh.K(https://github.com/YOURUSERNAME)  
*Maintained by techiecyber404*
