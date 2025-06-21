#!/usr/bin/env pwsh

Write-Host "Checking Windows password for EC2 instance..." -ForegroundColor Yellow

$instanceId = "i-0efd44f4d9230e85a"
$keyFile = "terraform\web-server-key"

do {
    $result = aws ec2 get-password-data --instance-id $instanceId --priv-launch-key $keyFile | ConvertFrom-Json
    
    if ($result.PasswordData) {
        Write-Host "Password retrieved successfully!" -ForegroundColor Green
        Write-Host "Password: $($result.PasswordData)" -ForegroundColor Cyan
        break
    } else {
        Write-Host "Password not ready yet, waiting 30 seconds..." -ForegroundColor Yellow
        Start-Sleep 30
    }
} while ($true)