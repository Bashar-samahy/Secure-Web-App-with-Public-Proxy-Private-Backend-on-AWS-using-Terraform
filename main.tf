module "s3_state" {
  source = "./S3-StateFile"
}

module "vpc" {
  source   = "./VPC"
  vpc_cidr = var.vpc_cidr
}

module "subnets" {
  source          = "./Subnets"
  vpc_id         = module.vpc.vpc_id
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
}

module "gateways" {
  source         = "./Gateways"
  vpc_id        = module.vpc.vpc_id
  public_subnet_ids = module.subnets.public_subnet_ids
}

module "security_groups" {
  source = "./SecurityGroups"
  vpc_id = module.vpc.vpc_id
}

module "routes" {
  source         = "./Routes"
  vpc_id        = module.vpc.vpc_id
  public_subnet_ids = module.subnets.public_subnet_ids
  private_subnet_ids = module.subnets.private_subnet_ids
  igw_id        = module.gateways.igw_id
  nat_gw_id     = module.gateways.nat_gw_id
}

module "instances" {
  source          = "./Instances"
  ami_id          = var.ami_id
  key_path        = "/home/bashar/TF-Project/project.pem"  # <-- Use full path
  key_name        = "project"                                   # <-- Must match AWS key pair name
  public_subnet_ids = module.subnets.public_subnet_ids
  private_subnet_ids = module.subnets.private_subnet_ids
  proxy_sg_id    = module.security_groups.proxy_sg_id
  backend_sg_id  = module.security_groups.backend_sg_id
  instance_count   = var.instance_count
}


module "elb" {
  source         = "./ELB"
  vpc_id        = module.vpc.vpc_id
  public_subnet_ids = module.subnets.public_subnet_ids
  private_subnet_ids = module.subnets.private_subnet_ids
  proxy_instances = module.instances.proxy_instances
  backend_instances = module.instances.backend_instances
  proxy_sg_id   = module.security_groups.proxy_sg_id
  backend_sg_id = module.security_groups.backend_sg_id
}

resource "local_file" "ips" {
  filename = "all-ips.txt"
  content  = <<-EOT
    Proxy Server IPs:
    %{for i, ip in module.instances.proxy_public_ips~}
    proxy-${i + 1}    ${ip}
    %{endfor~}
    
    Backend Server IPs:
    %{for i, ip in module.instances.backend_private_ips~}
    backend-${i + 1}    ${ip}
    %{endfor~}
  EOT
}