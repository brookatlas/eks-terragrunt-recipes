resource "aws_vpc" "vpc" {
  count = var.create ? 1 : 0
  cidr_block = var.cidr_block
  tags = {
    "managed-by" = "terraform"
    "Name" = var.vpc_name
  }

  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_subnet" "public_subnet" {
  count = var.create ? length(var.public_subnet_configurations) : 0
  vpc_id = aws_vpc.vpc[0].id
  cidr_block = var.public_subnet_configurations[count.index].cidr_block
  availability_zone = var.public_subnet_configurations[count.index].availability_zone
  map_public_ip_on_launch = true

  tags = {
    "managed-by" = "terraform"
    "Name" = var.public_subnet_configurations[count.index].name
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_internet_gateway" "public_subnets_igw" {
  count = var.create ? 1 : 0
  vpc_id = aws_vpc.vpc[0].id
  tags = {
    "managed-by" = "terraform"
  }
}

resource "aws_route_table" "public_subnets_rt" {
  count = var.create ? 1 : 0
  vpc_id = aws_vpc.vpc[count.index].id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public_subnets_igw[count.index].id
  }
  tags = {
    "managed-by" = "terraform"
    "Name" = "${var.vpc_name}-public-route-table"
  }
}

resource "aws_route_table_association" "public_subnets_rt_association" {
  count = var.create && var.enable_internet_gateway && length(aws_subnet.public_subnet) > 0 ? length(aws_subnet.public_subnet) : 0
  subnet_id = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_subnets_rt[0].id
}

resource "aws_subnet" "private_subnet" {
  count = var.create ? length(var.private_subnet_configurations) : 0
  vpc_id = aws_vpc.vpc[0].id
  cidr_block = var.private_subnet_configurations[count.index].cidr_block
  availability_zone = var.private_subnet_configurations[count.index].availability_zone

  tags = {
    "managed-by" = "terraform"
    "Name" = var.private_subnet_configurations[count.index].name
    "kubernetes.io/role/internal-elb" = 1
  }
}


resource "aws_eip" "aws_nat_gateway_eip" {
  count = var.create && var.enable_nat_gateway ? length(var.public_subnet_configurations) : 0
  tags = {
    "managed-by" = "terraform" 
  }
}

resource "aws_nat_gateway" "public_subnet_nat" {
  count = var.create && var.enable_nat_gateway ? length(var.public_subnet_configurations) : 0
  subnet_id = aws_subnet.public_subnet[count.index].id
  connectivity_type = "public"
  allocation_id = aws_eip.aws_nat_gateway_eip[count.index].id
  
  tags = {
    "managed-by" = "terraform"
  }
}

resource "aws_route_table" "private_subnet_route_table" {
  count = var.create && var.enable_nat_gateway ? length(var.private_subnet_configurations) : 0
  vpc_id = aws_vpc.vpc[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.public_subnet_nat[count.index % length(var.public_subnet_configurations)].id
  }

  tags = {
    "managed-by" = "terraform"
    "Name" = "${var.vpc_name}-private-route-table-${count.index}"
  }

  depends_on = [ aws_subnet.private_subnet ]
}

resource "aws_route_table_association" "private_subnet_rt_association" {
  count = var.create && var.enable_nat_gateway && length(var.private_subnet_configurations) > 0 ? length(var.private_subnet_configurations) : 0
  route_table_id = aws_route_table.private_subnet_route_table[count.index].id
  subnet_id = aws_subnet.private_subnet[count.index].id
}