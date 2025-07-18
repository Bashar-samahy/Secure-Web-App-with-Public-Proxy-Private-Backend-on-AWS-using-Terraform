resource "aws_subnet" "public" {
  for_each          = var.public_subnets
  vpc_id            = var.vpc_id
  cidr_block        = each.value
  availability_zone = each.key  # Now using actual AZ names
  map_public_ip_on_launch = true
  tags = {
    Name = "bashar-public-${each.key}"
  }
}

resource "aws_subnet" "private" {
  for_each          = var.private_subnets
  vpc_id            = var.vpc_id
  cidr_block        = each.value
  availability_zone = each.key  # Now using actual AZ names
  tags = {
    Name = "bashar-private-${each.key}"
  }
}