output "public_alb_dns" {
  value = module.elb.public_alb_dns
}

output "proxy_public_ips" {
  value = module.instances.proxy_public_ips
}

output "backend_private_ips" {
  value = module.instances.backend_private_ips
}

output "instance_public_ips" {
  description = "Public IPs of all proxy instances"
  value       = module.instances.proxy_public_ips
}

output "ssh_command" {
  description = "Example SSH command to connect to first proxy instance"
  value       = "ssh -i project.pem ec2-user@${module.instances.proxy_public_ips[0]}"
}