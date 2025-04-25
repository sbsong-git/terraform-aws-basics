# 프로덕션 환경 설정

environment = "prod"
project_name = "game-server"

# 네트워크 설정
vpc_cidr = "10.0.0.0/16"
subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]

# 게임 서버 설정
game_server_instance_type = "c5.2xlarge"
game_server_count = 4
enable_monitoring = true

# 태그
tags = {
  ManagedBy   = "Terraform"
  ServiceType = "GameServer"
  Environment = "Production"
  CostCenter  = "GameOps"
}
