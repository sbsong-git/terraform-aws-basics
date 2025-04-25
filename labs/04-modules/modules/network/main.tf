# 가용 영역 데이터 소스
data "aws_availability_zones" "available" {
  state = "available"
}

# VPC 생성
resource "aws_vpc" "this" {
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
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-igw-${var.environment}"
    }
  )
}

# 퍼블릭 서브넷
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  
  vpc_id                  = aws_vpc.this.id
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
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  
  vpc_id                  = aws_vpc.this.id
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
resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? (var.one_nat_gateway_per_az ? length(var.public_subnet_cidrs) : 1) : 0
  domain = "vpc"
  
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-nat-eip-${count.index + 1}-${var.environment}"
    }
  )
}

# NAT Gateway
resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway ? (var.one_nat_gateway_per_az ? length(var.public_subnet_cidrs) : 1) : 0
  
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-nat-gw-${count.index + 1}-${var.environment}"
    }
  )
  
  depends_on = [aws_internet_gateway.this]
}

# 퍼블릭 라우팅 테이블
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-public-rt-${var.environment}"
    }
  )
}

# 프라이빗 라우팅 테이블
resource "aws_route_table" "private" {
  count = var.enable_nat_gateway ? (var.one_nat_gateway_per_az ? length(var.private_subnet_cidrs) : 1) : 1
  
  vpc_id = aws_vpc.this.id
  
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-private-rt-${count.index + 1}-${var.environment}"
    }
  )
}

# 프라이빗 라우팅 테이블에 NAT 게이트웨이 경로 추가
resource "aws_route" "private_nat_gateway" {
  count = var.enable_nat_gateway ? (var.one_nat_gateway_per_az ? length(var.private_subnet_cidrs) : 1) : 0
  
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[count.index % length(aws_nat_gateway.this)].id
}

# 퍼블릭 서브넷에 라우팅 테이블 연결
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)
  
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# 프라이빗 서브넷에 라우팅 테이블 연결
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)
  
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[var.one_nat_gateway_per_az ? count.index % length(aws_route_table.private) : 0].id
}
