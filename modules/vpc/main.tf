# create vpc
resource "aws_vpc" "vpc" {
  cidr_block              = var.vpc_cidr
  instance_tenancy        = "default"
  enable_dns_hostnames    = true

  tags                    = {
    Name                  = "${var.project_name}-vpc"
  }
}

# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id                  = aws_vpc.vpc.id

  tags                    = {
    Name                  = "${var.project_name}-igw"
  }
}

# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

# create public subnet az1
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr_az1
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags                    = {
    Name                  = "${var.project_name}-public-subnet-az1"
  }
}

# create route table and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id                  = aws_vpc.vpc.id

  route {
    cidr_block            = "0.0.0.0/0"
    gateway_id            = aws_internet_gateway.internet_gateway.id
  }

  tags                    = {
    Name                  = "${var.project_name}-public-route-table"
  }
}

# associate public subnet az1 to "public route table"
resource "aws_route_table_association" "public_subnet_az1_route_table_association" {
  subnet_id               = aws_subnet.public_subnet_az1.id
  route_table_id          = aws_route_table.public_route_table.id
}


# create private data subnet az2
resource "aws_subnet" "private_data_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_data_subnet_cidr_az2
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = false

  tags                    = {
    Name                  = "${var.project_name}-private-data-subnet-az1"
  }
}

# create elastic ip for nat gateway
resource "aws_eip" "nat_eip" {
  domain                  = "vpc"

  tags                    = {
    Name                  = "${var.project_name}-nat-eip"
  }
}

# create nat gateway
resource "aws_nat_gateway" "nat_gateway-az2" {
  allocation_id           = aws_eip.nat_eip.id
  subnet_id               = aws_subnet.public_subnet_az1.id

  tags                    = {
    Name                  = "${var.project_name}-nat-gateway"
  }
  
  # to ensure proper ordering, it is recommended to add an explicit dependency
  depends_on              = [aws_internet_gateway.internet_gateway]
}

# create route table and add private route
resource "aws_route_table" "private_route_table" {
  vpc_id                  = aws_vpc.vpc.id

  route {
    cidr_block            = "0.0.0.0/0"
    nat_gateway_id        = aws_nat_gateway.nat_gateway-az2.id
  }

  tags                    = {
    Name                  = "${var.project_name}-private-route-table"
  }
}

# associate private data subnet az1 to "private route table"
resource "aws_route_table_association" "private_data_subnet_az2_route_table_association" {
  subnet_id               = aws_subnet.private_data_subnet_az2.id
  route_table_id          = aws_route_table.private_route_table.id
}