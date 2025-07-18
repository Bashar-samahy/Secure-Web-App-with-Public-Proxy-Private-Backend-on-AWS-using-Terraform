variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnets" {
  description = "Map of public subnets"
  type        = map(string)
}

variable "private_subnets" {
  description = "Map of private subnets"
  type        = map(string)
}