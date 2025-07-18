output "proxy_sg_id" {
  value = aws_security_group.proxy.id
}

output "backend_sg_id" {
  value = aws_security_group.backend.id
}