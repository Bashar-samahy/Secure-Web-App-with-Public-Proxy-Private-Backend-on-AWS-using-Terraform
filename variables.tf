variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "key_name" {
  description = "Name of existing AWS key pair"
  type        = string
  default     = "terraform-project"  # e.g., "terraform-project" (without .pm)
}

variable "key_path" {
  description = "Path to the private key file"
  type        = string
  default     = "./terraform-project.pem"  # Default path to your key file
}

variable "ami_id" {
  description = "CentOS AMI ID"
  type        = string
  default     = "ami-0150ccaf51ab55a51"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public subnets CIDR blocks"
  type        = map(string)
  default = {
    "us-east-1a" = "10.0.0.0/24"
    "us-east-1b" = "10.0.2.0/24"
  }
}

variable "private_subnets" {
  description = "Private subnets CIDR blocks"
  type        = map(string)
  default = {
    "us-east-1a" = "10.0.1.0/24"
    "us-east-1b" = "10.0.3.0/24"
  }
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 2  # Default to 2 instances for both proxy and backend
}