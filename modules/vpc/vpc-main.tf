resource "aws_vpc" "vpc_1" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = { Name = var.vpc_name}
}
resource "aws_internet_gateway" "ipg" {
  vpc_id = aws_vpc.vpc_1.id
  tags = { Name = "${var.vpc_name}-igw"}
}

resource "aws_subnet" "subnets" {
  count = length(var.subnet_cidrs)
  vpc_id = aws_vpc.vpc_1.id
  cidr_block = var.subnet_cidrs[count.index]
  availability_zone =  var.availability_zone[count.index]
  map_public_ip_on_launch = true
  tags = { Name = "${var.vpc_name}sn${count.index + 1}" }
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.vpc_1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ipg.id
  }
  tags = { Name = "${var.vpc_name}-public_route_table" }
}