# 1. VPC
resource "aws_vpc" "sample_vpc" {
  cidr_block = "10.0.0.0/24"
  enable_dns_hostnames = true
  tags = {
    Name = "sample_vpc"
  }
}

# 2. public subnet
## 2-1. create subnets
resource "aws_subnet" "sample_subnet_A_public" {
  # identify parent VPC
  vpc_id = "${aws_vpc.sample_vpc.id}"

  # create subnet on zone 1a
  availability_zone = "ap-northeast-1a"
  cidr_block        = "10.0.0.0/28"
  map_public_ip_on_launch = false

  tags = {
    Name = "sample_subnet_A_public"
  }
}
## 2-2. Internate Gateway
resource "aws_internet_gateway" "sample_igw" {
  vpc_id = "${aws_vpc.sample_vpc.id}"
  tags = {
    Name = "sample_igw"
  }
}
## 2-3. routing
### 2-3-1. create VPC route table (public)
resource "aws_route_table" "sample_route_table_A_public" {
  vpc_id       = "${aws_vpc.sample_vpc.id}"
  tags = {
    Name = "sample_route_table_A_public"
  }
}
### 2-3-2. create each route (public)
resource "aws_route" "sample_route_A_public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = "${aws_route_table.sample_route_table_A_public.id}"
  gateway_id             = "${aws_internet_gateway.sample_igw.id}"
}
### 2-3-3. create association routes and subnets (public)
resource "aws_route_table_association" "sample_route_association_A_public" {
  subnet_id      = "${aws_subnet.sample_subnet_A_public.id}"
  route_table_id = "${aws_route_table.sample_route_table_A_public.id}"
}


# 3. private
## 3-1. create private subnet
resource "aws_subnet" "sample_subnet_A_private" {
  # identify parent VPC
  vpc_id = "${aws_vpc.sample_vpc.id}"

  # create subnet on zone 1a
  availability_zone = "ap-northeast-1a"
  cidr_block        = "10.0.0.128/28"
  map_public_ip_on_launch = false
  tags = {
    Name = "sample_subnet_A_private"
  }
}
## 3-2. EIP and NAT for private subnet
resource "aws_eip" "sample_EIP_nat_A_private" {
  domain = "vpc"
  tags = {
    Name = "sample_EIP_nat_A_private"
  }
}
resource "aws_nat_gateway" "sample_nat_A_private" {
  # set public submet for NAT gateway
  subnet_id     = "${aws_subnet.sample_subnet_A_public.id}"
  # set EIP for the NAT gateway
  allocation_id = "${aws_eip.sample_EIP_nat_A_private.id}"
  tags = {
    Name = "sample_nat_A_private"
  }
}
## 3-3. route
### 3-3-1. create each route (private)
resource "aws_route_table" "sample_route_table_A_private" {
  vpc_id = "${aws_vpc.sample_vpc.id}"
  tags = {
    Name = "sample_route_table_A_private"
  }
}
### 3-3-2. create each route (private)
resource "aws_route" "sample_route_A_private" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = "${aws_route_table.sample_route_table_A_private.id}"
  nat_gateway_id         = "${aws_nat_gateway.sample_nat_A_private.id}"
}
# 3-3-3. create association routes and subnets (private)
resource "aws_route_table_association" "sample_route_association_A_private" {
  subnet_id      = "${aws_subnet.sample_subnet_A_private.id}"
  route_table_id = "${aws_route_table.sample_route_table_A_private.id}"
}
