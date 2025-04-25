# VPC 생성
resource "aws_vpc" "game_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-vpc-${var.environment}"
    }
  )
}

# 인터넷 게이트웨이
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.game_vpc.id
  
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-igw-${var.environment}"
    }
  )
}

# 퍼블릭 서브넷
resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidrs)
  
  vpc_id                  = aws_vpc.game_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
  map_public_ip_on_launch = true
  
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-public-subnet-${count.index + 1}-${var.environment}"
      Tier = "Public"
    }
  )
}

# 프라이빗 서브넷
resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidrs)
  
  vpc_id                  = aws_vpc.game_vpc.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
  map_public_ip_on_launch = false
  
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-private-subnet-${count.index + 1}-${var.environment}"
      Tier = "Private"
    }
  )
}

# EIP for NAT Gateway
resource "aws_eip" "nat_eip" {
  count = length(var.public_subnet_cidrs) > 0 ? 1 : 0
  domain = "vpc"
  
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-nat-eip-${var.environment}"
    }
  )
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  count = length(var.public_subnet_cidrs) > 0 ? 1 : 0
  
  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = aws_subnet.public_subnet[0].id
  
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-nat-gw-${var.environment}"
    }
  )
  
  depends_on = [aws_internet_gateway.igw]
}

# 퍼블릭 라우팅 테이블
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.game_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-public-rt-${var.environment}"
    }
  )
}

# 프라이빗 라우팅 테이블
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.game_vpc.id
  
  dynamic "route" {
    for_each = length(var.public_subnet_cidrs) > 0 ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat_gateway[0].id
    }
  }
  
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-private-rt-${var.environment}"
    }
  )
}

# 퍼블릭 서브넷에 라우팅 테이블 연결
resource "aws_route_table_association" "public_rta" {
  count = length(var.public_subnet_cidrs)
  
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# 프라이빗 서브넷에 라우팅 테이블 연결
resource "aws_route_table_association" "private_rta" {
  count = length(var.private_subnet_cidrs)
  
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}