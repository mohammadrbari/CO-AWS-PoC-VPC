# Step 1: Create a VPC
resource "aws_vpc" "co-poc-vpc" {
  cidr_block       = var.vpc-cidr
  tags = {
    Name = "CO-PoC-VPC"
  }
}
resource "aws_vpc_ipv4_cidr_block_association" "additional-cidr-vpc" {
  cidr_block = var.additional-cidr-vpc
  vpc_id = aws_vpc.co-poc-vpc.id
}

# Step 2: Create Private, Public and MGMT Subnets
resource "aws_subnet" "poc-private-subnets" {
  vpc_id = aws_vpc.co-poc-vpc.id
  #count = length(var.azs)
  count = length(var.poc-private-subnets)
  cidr_block = element(var.poc-private-subnets , count.index)
  availability_zone = element(var.azs , count.index)

  tags = {
    Name = "PoC-Private-SN-${count.index+1}"
  }
}

resource "aws_subnet" "poc-public-subnets" {
  vpc_id      = aws_vpc.co-poc-vpc.id
  #count      = length(var.azs)
  count       = length(var.poc-public-subnets)
  cidr_block  = element(var.poc-public-subnets , count.index)
  availability_zone = element(var.azs , count.index)

  tags = {
    Name = "PoC-Public-SN-${count.index+1}"
  }
}

resource "aws_subnet" "poc-mgmt-subnets" {
  vpc_id = aws_vpc.co-poc-vpc.id
  count = length(var.poc-mgmt-subnets)
  cidr_block = element(var.poc-mgmt-subnets, count.index )
  availability_zone = element(var.azs , count.index )

  tags = {

    Name = "PoC-MGMT-SN-${count.index+1}"
  }
}

# Step 3: Create route tables for public, private and mgmt subnets
resource "aws_route_table" "poc-public-rt" {
  vpc_id = aws_vpc.co-poc-vpc.id

  tags = {
    Name = "CO-PoC-Public"
  }
}

resource "aws_route_table" "poc-private-rt" {
  vpc_id = aws_vpc.co-poc-vpc.id

  tags = {
    Name = "CO-PoC-Private"
  }
}

resource "aws_route_table" "poc-mgmt-rt" {
  vpc_id = aws_vpc.co-poc-vpc.id

  tags = {

    Name = "CO-PoC-Mgmt"
  }
}

# Step 4: Create IGW
resource "aws_internet_gateway" "poc-igw" {

  vpc_id = aws_vpc.co-poc-vpc.id

  tags = {
    Name = "CO-PoC-IGW"
  }
}


# Step 5: Create 2xEIPs to use in NAT Gateway
resource "aws_eip" "nat-eip" {
  #count    = length(var.azs)
  count     = 1
  vpc       = true

  tags = {
    Name = "NGW-EIP--${count.index+1}"
  }
}


# Step 5.1: Create 1x NAT Gateway
resource "aws_nat_gateway" "poc-nat-gateway" {
  #count         = length(var.azs)
  count          = 1
  allocation_id = element(aws_eip.nat-eip.*.id , count.index)
  subnet_id     = element(aws_subnet.poc-public-subnets.*.id , count.index)

  tags = {
    Name = "NAT-GW--${count.index+1}"
  }
}

#Step 6: Add Default Routes to route table CO-PoC-Public towards IGW

resource "aws_route" "add-defaultroute-public-rt" {
  count                     = length(var.default-route)
  route_table_id            = aws_route_table.poc-public-rt.id
  destination_cidr_block    = element(var.default-route , count.index)
  gateway_id                = aws_internet_gateway.poc-igw.id
}
#Step 6.1: Add Default Routes to route table CO-PoC-Private towards NGW

resource "aws_route" "add-defaultroute-private-rt" {
  count                     = 1
  route_table_id            = aws_route_table.poc-private-rt.id
  destination_cidr_block    = element(var.default-route , count.index)
  gateway_id                = aws_nat_gateway.poc-nat-gateway[count.index].id
}

#Step 7: Route Table association of public,private and mgmt subnets
resource "aws_route_table_association" "public-subnet-association" {
  count          = length(var.poc-public-subnets)
  subnet_id      = element(aws_subnet.poc-public-subnets.*.id , count.index)
  route_table_id = aws_route_table.poc-public-rt.id
}

resource "aws_route_table_association" "private-subnet-association" {
  count          = length(var.poc-private-subnets)
  subnet_id      = element(aws_subnet.poc-private-subnets.*.id , count.index)
  route_table_id = aws_route_table.poc-private-rt.id
}


resource "aws_route_table_association" "mgmt-subnet-association" {
  count = length(var.poc-mgmt-subnets)
  subnet_id = element(aws_subnet.poc-mgmt-subnets.*.id, count.index )
  route_table_id = aws_route_table.poc-mgmt-rt.id
}

