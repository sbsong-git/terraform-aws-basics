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

# Security 모듈 호출
module "security" {
  source = "./modules/security"
  
  # 필수 변수
  region         = var.region
  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = module.network.vpc_id
  vpc_cidr       = var.vpc_cidr
  
  # 게임 서버 설정
  game_server_ports = var.game_server_ports
  enable_ssh        = true
  enable_http       = true
  
  # SSH 설정
  ssh_cidr_blocks  = ["0.0.0.0/0"]  # 실제 환경에서는 제한적으로 설정
  ssh_key_path     = "ssh/game_server_key.pub"
  
  # 태그
  tags = var.tags
}

# Game Server 모듈 호출
module "game_server" {
  source = "./modules/game-server"
  
  # 필수 변수
  region              = var.region
  project_name        = var.project_name
  environment         = var.environment
  vpc_id              = module.network.vpc_id
  subnet_ids          = module.network.public_subnet_ids
  security_group_id   = module.security.security_group_id
  key_name            = module.security.ssh_key_name
  instance_profile_name = module.security.instance_profile_name
  
  # 게임 서버 설정
  instance_type      = var.game_server_instance_type
  ami_id             = var.ami_id
  instance_count     = var.game_server_count
  enable_detailed_monitoring = var.enable_detailed_monitoring
  
  # 볼륨 설정
  root_volume_size   = 20
  data_volume_size   = 50
  
  # 네트워크 설정
  enable_public_ip   = true
  
  # 태그
  tags = var.tags
  
  # 의존성 설정
  depends_on = [
    module.network,
    module.security
  ]
}