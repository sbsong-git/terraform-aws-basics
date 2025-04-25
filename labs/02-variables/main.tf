# 프로바이더 설정
provider "aws" {
  region = var.region
}

# VPC 생성
resource "aws_vpc" "game_server_vpc" {
  cidr_block = var.vpc_cidr
  
  tags = merge(
    var.tags,
    {
      Name        = "${var.project_name}-vpc-${var.environment}"
      Environment = var.environment
    }
  )
}

# 서브넷 생성
resource "aws_subnet" "game_server_subnet" {
  count      = length(var.subnet_cidrs)
  vpc_id     = aws_vpc.game_server_vpc.id
  cidr_block = var.subnet_cidrs[count.index]
  
  availability_zone = "${var.region}${count.index == 0 ? "a" : "c"}"
  
  tags = merge(
    var.tags,
    {
      Name        = "${var.project_name}-subnet-${count.index + 1}-${var.environment}"
      Environment = var.environment
    }
  )
}

# 보안 그룹 생성
resource "aws_security_group" "game_server_sg" {
  name        = "${var.project_name}-sg-${var.environment}"
  description = "Security group for game servers"
  vpc_id      = aws_vpc.game_server_vpc.id
  
  # 게임 서버 기본 포트 (예: 7777)
  ingress {
    from_port   = 7777
    to_port     = 7777
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Game server port"
  }
  
  # SSH 접속
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }
  
  # 모든 아웃바운드 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = merge(
    var.tags,
    {
      Name        = "${var.project_name}-sg-${var.environment}"
      Environment = var.environment
    }
  )
}

# S3 버킷 생성 (게임 에셋 저장용)
resource "aws_s3_bucket" "game_assets" {
  bucket = "${var.project_name}-assets-${var.environment}-${random_string.bucket_suffix.result}"
  
  tags = merge(
    var.tags,
    {
      Name        = "${var.project_name}-assets-${var.environment}"
      Environment = var.environment
    }
  )
}

# 버킷 이름용 랜덤 문자열
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}
