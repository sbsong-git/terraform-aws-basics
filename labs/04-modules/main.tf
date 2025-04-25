# 프로바이더 설정
provider "aws" {
  region = var.region
}

# Terraform 설정
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 0.14"
}

# 가용 영역 데이터 소스
data "aws_availability_zones" "available" {
  state = "available"
}

# Network 모듈 호출
module "network" {
  source = "./modules/network"
  
  # 필수 변수
  region              = var.region
  project_name        = var.project_name
  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  
  # 태그
  tags = var.tags
}

# TODO: Security 모듈 호출
# module "security" {
#   source = "./modules/security"
#   
#   # 필수 변수 전달
#   ...
# }

# TODO: Game Server 모듈 호출
# module "game_server" {
#   source = "./modules/game-server"
#   
#   # 필수 변수 전달
#   ...
#   
#   # 의존성 설정
#   depends_on = [
#     module.network,
#     module.security
#   ]
# }
