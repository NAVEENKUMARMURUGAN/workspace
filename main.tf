resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name = "My-VPC"
  }
}

resource "aws_subnet" "public_subnet" {
  count = var.num_availability_zones

  vpc_id            = aws_vpc.vpc.id
  cidr_block         = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 1)
  availability_zone = data.aws_availability_zones.available[count.index].name
  map_public_ip_on_launch = true

  tags = {
    Name = format("Public-Subnet-%d", count.index + 1)
  }
}

resource "aws_subnet" "private_subnet" {
  count = var.num_availability_zones

  vpc_id            = aws_vpc.vpc.id
  cidr_block         = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 1 + var.num_availability_zones)
  availability_zone = data.aws_availability_zones.available[count.index].name
  map_public_ip_on_launch = false

  tags = {
    Name = format("Private-Subnet-%d", count.index + 1)
  }
}

data "aws_availability_zones" "available" {}