data "aws_availability_zones" "az" {
  state = "available"
}

locals {

  availability_zones = data.aws_availability_zones.az.names

  public_subnet_ids  = [for id in aws_subnet.public : id.id]
  private_subnet_ids = [for id in aws_subnet.private : id.id]
}

locals {
  azs                = { for idx, az in local.availability_zones : az => idx }
  public_cidr_block  = cidrsubnet(var.cidr_block, 1, 0)
  private_cidr_block = cidrsubnet(var.cidr_block, 1, 1)
}
