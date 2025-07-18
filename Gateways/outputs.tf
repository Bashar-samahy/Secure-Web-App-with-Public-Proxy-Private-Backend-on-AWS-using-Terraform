output "igw_id" {
  value = aws_internet_gateway.gw.id
}

output "nat_gw_id" {
  value = aws_nat_gateway.nat.id
}