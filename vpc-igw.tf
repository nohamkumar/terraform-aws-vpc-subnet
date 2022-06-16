resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.dns_hostnames_enabled
  enable_dns_support   = var.dns_support_enabled

  tags = merge(
    module.this.tags,
    {
      "Name" = "${module.this.id}"
    }
  )
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    module.this.tags,
    {
      "Name" = "${module.this.id}"
    }
  )
}
