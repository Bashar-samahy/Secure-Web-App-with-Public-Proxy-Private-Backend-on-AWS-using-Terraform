resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "bashar-main-gw"
  }
}

resource "aws_eip" "nat" {
  # Remove this line: domain = "vpc"
  tags = {
    Name = "bashar-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet_ids[keys(var.public_subnet_ids)[0]]
  tags = {
    Name = "bashar-main-nat"
  }
}