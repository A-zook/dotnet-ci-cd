variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "windows_ami" {
  description = "Windows Server AMI ID"
  type        = string
  default     = "ami-0c02fb55956c7d316" # Windows Server 2022
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}