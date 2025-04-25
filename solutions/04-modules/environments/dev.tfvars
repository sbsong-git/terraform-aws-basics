# 개발 환경 설정

# 기본 설정
region        = "ap-northeast-2"
project_name  = "game-server"
environment   = "dev"

# 네트워크 설정
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]

# 게임 서버 설정
game_server_count          = 1
game_server_instance_type  = "t3.medium"
game_server_ports = {
  from_port = 7000
  to_port   = 8000
}

# 모니터링 설정
enable_detailed_monitoring = false

# 태그
tags = {
  ManagedBy   = "Terraform"
  Project     = "GameServer"
  Environment = "Development"
  Owner       = "DevOps"
  CostCenter  = "GameDev"
}