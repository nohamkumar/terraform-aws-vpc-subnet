

resource "aws_subnet" "public" {
  for_each = local.azs

  vpc_id            = aws_vpc.main.id
  availability_zone = each.key
  cidr_block        = cidrsubnet(local.public_cidr_block, 3, each.value)

  tags = merge(
    module.this.tags,
    {
      "Name" = "${module.this.id}-public-${each.key}"
      "Type" = "public"
    },
  )
}

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  tags = merge(
    module.this.tags,
    {
      "Name" = "${module.this.id}-public"
      "Type" = "public"
    },
  )
}

resource "aws_route" "public" {

  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = [aws_route_table.public]
}

resource "aws_route_table_association" "public" {
  for_each = local.azs

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
  depends_on = [
    aws_subnet.public,
    aws_route_table.public,
  ]
}

resource "aws_eip" "public" {
  count = var.nat_gateway_enabled == true ? 1 : 0

  vpc = true
  tags = merge(
    module.this.tags,
    {
      "Name" = "${module.this.id}-eip"
      "Type" = "public"
    },
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "public" {
  count = var.nat_gateway_enabled == true ? 1 : 0

  allocation_id = aws_eip.public[0].id
  subnet_id     = element(local.public_subnet_ids, 0)
  depends_on    = [aws_subnet.public]

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    module.this.tags,
    {
      "Name" = "${module.this.id}-public"
      "Type" = "public"
    },
  )
}
