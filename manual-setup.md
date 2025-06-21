# Manual Setup Alternative

## If Windows Password Not Available Yet

### Option 1: Get Password from AWS Console
1. Go to AWS EC2 Console
2. Select instance `i-0efd44f4d9230e85a`
3. Actions → Security → Get Windows Password
4. Upload `terraform/web-server-key` file
5. Copy the decrypted password

### Option 2: Test Without Ansible First
```bash
# Test .NET app locally
cd webapp/WebApp
dotnet run
# Visit: http://localhost:5000
```

### Option 3: Manual IIS Setup
1. RDP to `54.242.141.137` using Administrator and password
2. Install IIS: `Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole`
3. Download .NET Hosting Bundle manually
4. Copy published files to `C:\inetpub\wwwroot\webapp`

### Option 4: Skip to GitHub Setup
1. Create GitHub repo
2. Add secrets (use placeholder password for now)
3. Push code - pipeline will fail but you can see the workflow
4. Update password secret when available
5. Re-run workflow

## Quick GitHub Test
```bash
# Create a simple change to test pipeline
echo "<!-- Test change -->" >> webapp/WebApp/Views/Home/Index.cshtml
git add .
git commit -m "Test CI/CD pipeline"
git push origin main
```

Monitor at: `https://github.com/YOUR_USERNAME/REPO_NAME/actions`