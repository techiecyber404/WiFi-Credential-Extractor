# Security Policy

## Supported Versions
Only the latest version receives security updates:
| Version | Supported          |
| ------- | ------------------ |
| 2.x     | ✅ Yes             |
| < 2.0   | ❌ No              |

## Responsible Disclosure
**Important**: This tool deals with sensitive network credentials. 

### Reporting Vulnerabilities
Email: [security@techiecyber404.example](mailto:security@techiecyber404.example)  
PGP Key: [Provide if available]  

Expected response time:  
- Critical issues: 24 hours  
- Other reports: 3 business days  

### Guidelines
- **Do not** publicly post vulnerabilities without prior discussion  
- Include proof-of-concept code if possible  
- Specify how to reproduce the issue  

## Ethical Use Requirements
By using this software, you agree:
1. Only test networks you own or have written permission to access  
2. Never extract credentials from public/unauthorized networks  
3. Comply with all applicable laws (Computer Fraud and Abuse Act, GDPR, etc.)  

## Security Best Practices
- Always run in `-LocalOnly` mode on untrusted systems  
- Delete extracted credentials after use (`del %TEMP%\wifi_passwords*`)  
- Monitor GitHub for security updates  
