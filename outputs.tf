#------------------
### VPC OUTPUTS
#------------------

output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC"
}

output "vpc_cidr_block" {
  value       = aws_vpc.main.cidr_block
  description = "The primary IPv4 CIDR block of the VPC"
}

output "igw_id" {
  value       = aws_internet_gateway.igw.id
  description = "IGW ID"
}
#------------------
### SUBNET OUTPUTS
#------------------

output "public_subnet_ids" {
  description = "List of the created public subnets IDs"
  value = [
    for id in aws_subnet.public : id.id
  ]
}

output "private_subnet_ids" {
  description = "List of the created private subnets IDs"
  value = [
    for id in aws_subnet.private : id.id
  ]
}

output "eip_id" {
  value       = aws_eip.public.*.id
  description = "EIP ID"
}

output "ngw_id" {
  value       = aws_nat_gateway.public.*.id
  description = "NAT Gateway ID"
}
