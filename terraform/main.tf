terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Security Group
resource "aws_security_group" "web_sg" {
  name_prefix = "web-server-sg"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 5985
    to_port     = 5986
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Key Pair
resource "aws_key_pair" "web_key" {
  key_name   = "web-server-key"
  public_key = file("${path.module}/web-server-key.pub")
}

# EC2 Instance
resource "aws_instance" "web_server" {
  ami                    = var.windows_ami
  instance_type          = var.instance_type
  key_name              = aws_key_pair.web_key.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  
  user_data = <<-EOF
    <powershell>
    # Enable WinRM
    winrm quickconfig -q
    winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="512"}'
    winrm set winrm/config '@{MaxTimeoutms="1800000"}'
    winrm set winrm/config/service '@{AllowUnencrypted="true"}'
    winrm set winrm/config/service/auth '@{Basic="true"}'
    netsh advfirewall firewall add rule name="WinRM-HTTP" dir=in localport=5985 protocol=TCP action=allow
    </powershell>
  EOF
  
  tags = {
    Name = "WebServer"
  }
}