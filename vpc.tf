data "aws_availability_zones" "available_az" {}

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc-cidr}"
  enable_dns_hostnames = true
}

resource "aws_subnet" "public" {
  count = "${length(var.public_subnets) > 0 ? length(var.public_subnets) : 0}"

  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.public_subnets[count.index]}"
  availability_zone = "${data.aws_availability_zones.available_az.names[count.index]}"

  tags = "${
    merge(
        map(
            "Name", "PUBLIC-SUBNET-${count.index + 1}",
            "ResourceType", "Subnet"
        ))
  }"
}

resource "aws_route_table" "subnet-route-table" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route" "subnet-route" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
  route_table_id         = "${aws_route_table.subnet-route-table.id}"
}

resource "aws_route_table_association" "public" {
  count = "${length(var.public_subnets) > 0 ? length(var.public_subnets) : 0}"

  route_table_id = "${aws_route_table.subnet-route-table.id}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
}

resource "aws_eip" "nat" {
  vpc = true

  lifecycle {
    create_before_destroy = true
  }

  tags = "${
    merge(
        map(
            "Name", "NGW-EIP",
            "ResourceType", "ElasticIP"
        ))
  }"
}

resource "aws_nat_gateway" "nat" {
  count = "${length(var.private_subnets) > 0 ? 1 : 0}"

  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"

  tags = "${
    merge(
        map(
            "Name", "NGW",
            "ResourceType", "NatGateway"
        ))
  }"
}

resource "aws_subnet" "private" {
  count = "${length(var.private_subnets) > 0 ? length(var.private_subnets) : 0}"

  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.private_subnets[count.index]}"
  availability_zone       = "${data.aws_availability_zones.available_az.names[count.index]}"
  map_public_ip_on_launch = "false"

  tags = "${
    merge(
        map(
            "Name", "PRIVATE-SUBNET-${count.index + 1}",
            "ResourceType", "Subnet"
        ))
  }"
}

resource "aws_route_table" "private" {
  count = "${length(var.private_subnets) > 0 ? 1 : 0}"

  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.nat.*.id, 0)}"
  }

  tags = "${
    merge(
        map(
            "Name", "PRIVATE-ROUTETABLE",
            "ResourceType", "RouteTable"
        ))
  }"
}

resource "aws_route_table_association" "private_association" {
  count = "${length(var.private_subnets) > 0 ? length(var.private_subnets) : 0}"

  route_table_id = "${aws_route_table.private.id}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
}
