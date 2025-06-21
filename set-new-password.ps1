#!/usr/bin/env pwsh

$instanceId = "i-0efd44f4d9230e85a"
$newPassword = "TempPass123!"

Write-Host "Setting new Administrator password via Systems Manager..." -ForegroundColor Yellow

# Create the PowerShell command to change password
$command = @"
net user Administrator $newPassword
"@

# Execute via Systems Manager
try {
    $result = aws ssm send-command `
        --instance-ids $instanceId `
        --document-name "AWS-RunPowerShellScript" `
        --parameters "commands=`"$command`"" `
        --output json | ConvertFrom-Json
    
    $commandId = $result.Command.CommandId
    Write-Host "Command sent. Command ID: $commandId" -ForegroundColor Green
    
    # Wait a moment then check status
    Start-Sleep 10
    
    $status = aws ssm get-command-invocation `
        --command-id $commandId `
        --instance-id $instanceId `
        --output json | ConvertFrom-Json
    
    if ($status.Status -eq "Success") {
        Write-Host "Password changed successfully!" -ForegroundColor Green
        Write-Host "New Administrator password: $newPassword" -ForegroundColor Cyan
        Write-Host "Update your ansible/inventory.yml with this password" -ForegroundColor Yellow
    } else {
        Write-Host "Command status: $($status.Status)" -ForegroundColor Red
        Write-Host "Output: $($status.StandardOutputContent)" -ForegroundColor White
    }
    
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
    Write-Host "Make sure SSM Agent is running on the instance" -ForegroundColor Yellow
}