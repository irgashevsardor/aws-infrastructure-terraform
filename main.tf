provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = var.environment
    }
  }
}

# VPC
resource "aws_vpc" "itra_vpc" {
  cidr_block = var.vpc_cidr
}

# Public Subnet on AZ-1
resource "aws_subnet" "itra_public_subnet_az1" {
  vpc_id            = aws_vpc.itra_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

# Private Subnet on AZ-1
resource "aws_subnet" "itra_private_subnet_az1" {
  vpc_id            = aws_vpc.itra_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
}

# Public Subnet on AZ-2
resource "aws_subnet" "itra_public_subnet_az2" {
  vpc_id            = aws_vpc.itra_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"
}

# Private Subnet on AZ-2
resource "aws_subnet" "itra_private_subnet_az2" {
  vpc_id            = aws_vpc.itra_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
}

# Internet Gateway
resource "aws_internet_gateway" "itra_internet_gateway" {
  vpc_id = aws_vpc.itra_vpc.id
}

# Elastic IP AZ-1
resource "aws_eip" "itra_eip_nat_az1" {
  depends_on = [aws_internet_gateway.itra_internet_gateway]
}

# Elastic IP AZ-2
resource "aws_eip" "itra_eip_nat_az2" {
  depends_on = [aws_internet_gateway.itra_internet_gateway]
}

# NAT AZ-1
resource "aws_nat_gateway" "itra_nat_az1" {
  allocation_id = aws_eip.itra_eip_nat_az1.id
  subnet_id     = aws_subnet.itra_public_subnet_az1.id
}

# NAT AZ-2
resource "aws_nat_gateway" "itra_nat_az2" {
  allocation_id = aws_eip.itra_eip_nat_az2.id
  subnet_id     = aws_subnet.itra_public_subnet_az2.id
}

# Public Route Table
resource "aws_route_table" "itra_public_route_table" {
  vpc_id = aws_vpc.itra_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.itra_internet_gateway.id
  }
}

# Private Route Table AZ-1
resource "aws_route_table" "itra_route_table_az1" {
  vpc_id = aws_vpc.itra_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.itra_nat_az1.id
  }
}

# Private Route Table AZ-2
resource "aws_route_table" "itra_route_table_az2" {
  vpc_id = aws_vpc.itra_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.itra_nat_az2.id
  }
}

# Public Route Table Association AZ-1
resource "aws_route_table_association" "itra_public_route_table_association_az1" {
  subnet_id      = aws_subnet.itra_public_subnet_az1.id
  route_table_id = aws_route_table.itra_public_route_table.id
}

# Private Route Table Association AZ-1
resource "aws_route_table_association" "itra_private_route_table_association_az1" {
  subnet_id      = aws_subnet.itra_private_subnet_az1.id
  route_table_id = aws_route_table.itra_route_table_az1.id
}

# Public Route Table Association AZ-2
resource "aws_route_table_association" "itra_public_route_table_association_az2" {
  subnet_id      = aws_subnet.itra_public_subnet_az2.id
  route_table_id = aws_route_table.itra_public_route_table.id
}

# Private Route Table Association AZ-2
resource "aws_route_table_association" "itra_private_route_table_association_az2" {
  subnet_id      = aws_subnet.itra_private_subnet_az2.id
  route_table_id = aws_route_table.itra_route_table_az2.id
}
