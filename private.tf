

resource "aws_subnet" "private" {
  for_each = local.azs

  vpc_id            = aws_vpc.main.id
  availability_zone = each.key
  cidr_block        = cidrsubnet(local.private_cidr_block, 3, each.value)

  tags = merge(
    module.this.tags,
    {
      "Name" = "${module.this.id}-private-${each.key}"
      "Type" = "private"
    },
  )
}

resource "aws_route_table" "private" {

  vpc_id = aws_vpc.main.id

  tags = merge(
    module.this.tags,
    {
      "Name" = "${module.this.id}-private"
      "Type" = "private"
    },
  )
}

resource "aws_route_table_association" "private" {
  for_each = local.azs

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private.id
  depends_on = [
    aws_subnet.private,
    aws_route_table.private,
  ]
}

resource "aws_route" "default" {
  count = var.nat_gateway_enabled ? 1 : 0

  route_table_id         = aws_route_table.private.id
  nat_gateway_id         = aws_nat_gateway.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = [aws_route_table.private]
}
