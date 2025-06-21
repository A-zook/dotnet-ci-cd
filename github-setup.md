# GitHub CI/CD Setup & Monitoring Guide

## 🚀 How to Monitor Your CI/CD Pipeline

### 1. Create GitHub Repository
```bash
# Create repo on GitHub.com, then:
git remote add origin https://github.com/YOUR_USERNAME/aws-ci-cd.git
git branch -M main
git push -u origin main
```

### 2. Configure GitHub Secrets
Go to: **Repository → Settings → Secrets and variables → Actions**

Add these secrets:
- `EC2_PUBLIC_IP`: `54.242.141.137`
- `WINDOWS_PASSWORD`: (Get from: `.\get-password.ps1`)

### 3. Monitor CI/CD Pipeline

#### 📊 Where to Watch:
- **GitHub Actions Tab**: `https://github.com/YOUR_USERNAME/aws-ci-cd/actions`
- **Workflow Runs**: Shows each deployment attempt
- **Live Logs**: Real-time build and deployment progress

#### 🔍 What You'll See:
```
✅ Setup .NET
✅ Build Application  
✅ Create Deployment Package
✅ Setup Python
✅ Install Ansible
✅ Deploy with Ansible
```

#### 🚨 Pipeline Triggers:
- **Push to main branch** → Automatic deployment
- **Manual trigger** → Actions tab → "Run workflow"

### 4. Pipeline Status Indicators

| Status | Meaning |
|--------|---------|
| 🟡 **In Progress** | Pipeline is running |
| ✅ **Success** | Deployment completed |
| ❌ **Failed** | Check logs for errors |
| ⏸️ **Cancelled** | Manually stopped |

### 5. Troubleshooting
- **Failed builds**: Check "Build Application" step
- **Ansible errors**: Verify Windows password and connectivity
- **Deployment issues**: Check EC2 instance status

### 6. Test Your Pipeline
```bash
# Make a change to trigger deployment
echo "Updated $(Get-Date)" >> webapp/WebApp/Views/Home/Index.cshtml
git add .
git commit -m "Test deployment"
git push origin main
```

Then watch: `https://github.com/YOUR_USERNAME/aws-ci-cd/actions`