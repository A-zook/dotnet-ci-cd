#!/usr/bin/env pwsh

Write-Host "Building .NET Application..." -ForegroundColor Green

# Navigate to project directory
Set-Location WebApp

# Restore dependencies
dotnet restore

# Build the application
dotnet build --configuration Release

# Publish the application
dotnet publish --configuration Release --output ../publish

Write-Host "Build completed successfully!" -ForegroundColor Green