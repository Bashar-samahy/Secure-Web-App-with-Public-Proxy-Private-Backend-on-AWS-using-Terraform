output "proxy_instances" {
  value = aws_instance.proxy.*.id
}

output "proxy_public_ips" {
  description = "List of public IP addresses of proxy instances"
  value       = aws_instance.proxy[*].public_ip
}

output "backend_instances" {
  value = aws_instance.backend.*.id
}

output "backend_private_ips" {
  description = "List of private IP addresses of backend instances"
  value       = aws_instance.backend[*].private_ip
}

