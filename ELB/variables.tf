variable "vpc_id" {
  description = "VPC ID"
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

variable "proxy_instances" {
  description = "List of proxy instance IDs"
  type        = list(string)
}

variable "backend_instances" {
  description = "List of backend instance IDs"
  type        = list(string)
}

variable "proxy_sg_id" {
  description = "Proxy security group ID"
  type        = string
}

variable "backend_sg_id" {
  description = "Backend security group ID"
  type        = string
}