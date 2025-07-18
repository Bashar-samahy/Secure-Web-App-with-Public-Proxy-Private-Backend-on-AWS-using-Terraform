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

variable "igw_id" {
  description = "Internet Gateway ID"
  type        = string
}

variable "nat_gw_id" {
  description = "NAT Gateway ID"
  type        = string
}
