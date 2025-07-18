variable "ami_id" {
  description = "AMI ID for instances"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "public_subnet_ids" {
  description = "Map of public subnet IDs"
  type        = map(string)
}

variable "private_subnet_ids" {
  description = "Map of private subnet IDs"
  type        = map(string)
}

variable "proxy_sg_id" {
  description = "Proxy security group ID"
  type        = string
}

variable "backend_sg_id" {
  description = "Backend security group ID"
  type        = string
}