#!/usr/bin/env pwsh

$instanceId = "i-0efd44f4d9230e85a"
$privateKeyPath = "terraform\web-server-key"

Write-Host "Getting encrypted password data..." -ForegroundColor Yellow

# Get the encrypted password data
$passwordData = aws ec2 get-password-data --instance-id $instanceId --output json | ConvertFrom-Json

if ([string]::IsNullOrEmpty($passwordData.PasswordData)) {
    Write-Host "Password not ready yet. Windows is still initializing..." -ForegroundColor Red
    Write-Host "Try again in 5-10 minutes, or use AWS Console method." -ForegroundColor Yellow
    exit 1
}

Write-Host "Encrypted password found! Decrypting..." -ForegroundColor Green

# Save encrypted data to temp file
$encryptedData = $passwordData.PasswordData
$tempFile = "temp_encrypted.txt"
$encryptedData | Out-File -FilePath $tempFile -Encoding ASCII

# Decrypt using OpenSSL (if available) or show manual steps
try {
    $decryptedPassword = openssl rsautl -decrypt -inkey $privateKeyPath -in $tempFile
    Write-Host "Decrypted Password: $decryptedPassword" -ForegroundColor Cyan
    Remove-Item $tempFile
} catch {
    Write-Host "OpenSSL not found. Here's the encrypted data:" -ForegroundColor Yellow
    Write-Host $encryptedData -ForegroundColor White
    Write-Host "`nTo decrypt manually:" -ForegroundColor Yellow
    Write-Host "1. Save the above data to a file" -ForegroundColor White
    Write-Host "2. Use: openssl rsautl -decrypt -inkey terraform\web-server-key -in encrypted.txt" -ForegroundColor White
    Remove-Item $tempFile -ErrorAction SilentlyContinue
}