# AWS CI/CD Pipeline with Terraform, Ansible & GitHub Actions

## Setup Instructions

### 1. Generate SSH Key Pair
```bash
ssh-keygen -t rsa -b 2048 -f terraform/web-server-key
```

### 2. Deploy Infrastructure
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 3. Setup Ansible
```bash
cd ansible
# Update inventory.yml with EC2 public IP and Windows password
ansible-playbook -i inventory.yml setup-iis.yml
```

### 4. Configure GitHub Secrets
- `EC2_PUBLIC_IP`: Your EC2 instance public IP
- `WINDOWS_PASSWORD`: Windows Administrator password

### 5. Deploy Application
Push to main branch to trigger automatic deployment.

## Manual Deployment
```bash
cd webapp
./build.ps1
cd ../ansible
ansible-playbook -i inventory.yml deploy-app.yml --extra-vars "app_source_path=../webapp/publish/"
```