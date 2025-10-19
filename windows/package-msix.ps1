# PowerShell script to create MSIX package using native Windows tools
# This replaces the need for dart run msix:create

param(
    [Parameter(Mandatory=$true)]
    [string]$Version
)

$ErrorActionPreference = "Stop"

Write-Host "Creating MSIX package for version $Version" -ForegroundColor Cyan

# Paths
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$BuildDir = Join-Path $ProjectRoot "build\windows\x64\runner\Release"
$MsixStaging = Join-Path $ProjectRoot "build\windows\msix_staging"
$OutputDir = Join-Path $ProjectRoot "build\windows\x64\runner\Release"
$ManifestTemplate = Join-Path $PSScriptRoot "AppxManifest.xml"
$IconPath = Join-Path $ProjectRoot "Assets\Icon512x512.ico"

# Clean and create staging directory
if (Test-Path $MsixStaging) {
    Remove-Item -Path $MsixStaging -Recurse -Force
}
New-Item -ItemType Directory -Path $MsixStaging -Force | Out-Null
New-Item -ItemType Directory -Path "$MsixStaging\Assets" -Force | Out-Null

Write-Host "Copying build artifacts to staging directory..." -ForegroundColor Yellow

# Copy all files from Release build
Get-ChildItem -Path $BuildDir | Copy-Item -Destination $MsixStaging -Recurse -Force

# Copy icon to Assets folder
Copy-Item -Path $IconPath -Destination "$MsixStaging\Assets\Icon512x512.ico" -Force

Write-Host "Generating AppxManifest.xml..." -ForegroundColor Yellow

# Convert version format (1.0.0 -> 1.0.0.0)
$VersionParts = $Version -split '-'
$BaseVersion = $VersionParts[0]
if ($BaseVersion -notmatch '^\d+\.\d+\.\d+\.\d+$') {
    # Add .0 if only 3 parts
    if ($BaseVersion -match '^\d+\.\d+\.\d+$') {
        $BaseVersion = "$BaseVersion.0"
    } else {
        throw "Invalid version format: $Version"
    }
}

# Read and update manifest
$ManifestContent = Get-Content -Path $ManifestTemplate -Raw
$ManifestContent = $ManifestContent -replace 'VERSION_PLACEHOLDER', $BaseVersion

# Write manifest to staging
$ManifestPath = Join-Path $MsixStaging "AppxManifest.xml"
Set-Content -Path $ManifestPath -Value $ManifestContent -Encoding UTF8

Write-Host "Creating MSIX package with makeappx.exe..." -ForegroundColor Yellow

# Find makeappx.exe in Windows SDK
$MakeAppx = Get-ChildItem "C:\Program Files (x86)\Windows Kits\10\bin\*\x64\makeappx.exe" -ErrorAction SilentlyContinue |
            Sort-Object -Property FullName -Descending |
            Select-Object -First 1

if (-not $MakeAppx) {
    throw "makeappx.exe not found. Please install Windows 10 SDK."
}

Write-Host "Using makeappx: $($MakeAppx.FullName)" -ForegroundColor Gray

# Create MSIX package
$OutputMsix = Join-Path $OutputDir "tkit.msix"
& $MakeAppx.FullName pack /d $MsixStaging /p $OutputMsix /o

if ($LASTEXITCODE -ne 0) {
    throw "makeappx.exe failed with exit code $LASTEXITCODE"
}

Write-Host "MSIX package created successfully: $OutputMsix" -ForegroundColor Green

# Auto-signing with self-signed certificate for testing (optional)
# Note: This creates unsigned MSIX by default (same as install_certificate: false in pubspec.yaml)
#
# To enable auto-signing for local testing:
# 1. Uncomment the code below
# 2. The script will generate a self-signed certificate
# 3. Users will need to install the certificate to trust the app
#
# Find signtool.exe
# $SignTool = Get-ChildItem "C:\Program Files (x86)\Windows Kits\10\bin\*\x64\signtool.exe" -ErrorAction SilentlyContinue |
#             Sort-Object -Property FullName -Descending |
#             Select-Object -First 1
#
# if ($SignTool) {
#     Write-Host "Creating self-signed certificate for testing..." -ForegroundColor Yellow
#     $CertName = "CN=evobug"
#     $CertPath = Join-Path $ProjectRoot "build\windows\TKit-SelfSigned.pfx"
#     $CertPassword = "test123"
#
#     # Create self-signed certificate
#     $Cert = New-SelfSignedCertificate -Type Custom -Subject $CertName `
#         -KeyUsage DigitalSignature -FriendlyName "TKit Test Certificate" `
#         -CertStoreLocation "Cert:\CurrentUser\My" `
#         -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.3", "2.5.29.19={text}")
#
#     # Export certificate
#     $CertPasswordSecure = ConvertTo-SecureString -String $CertPassword -Force -AsPlainText
#     Export-PfxCertificate -Cert $Cert -FilePath $CertPath -Password $CertPasswordSecure | Out-Null
#
#     # Sign MSIX
#     & $SignTool.FullName sign /fd SHA256 /a /f $CertPath /p $CertPassword $OutputMsix
#
#     if ($LASTEXITCODE -eq 0) {
#         Write-Host "MSIX signed successfully with self-signed certificate" -ForegroundColor Green
#         Write-Host "Certificate exported to: $CertPath" -ForegroundColor Gray
#     }
#
#     # Clean up certificate from store
#     Remove-Item -Path "Cert:\CurrentUser\My\$($Cert.Thumbprint)" -Force
# }

Write-Host "Done!" -ForegroundColor Green
Write-Host "Note: MSIX is unsigned. For production, sign with a valid certificate using signtool.exe" -ForegroundColor Yellow
