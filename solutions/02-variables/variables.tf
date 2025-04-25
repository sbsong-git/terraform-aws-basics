# 기본 설정 변수

variable "region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "environment" {
  description = "환경 이름 (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "프로젝트 이름"
  type        = string
  default     = "game-server"
}

# 네트워크 설정 변수

variable "vpc_cidr" {
  description = "VPC CIDR 블록"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  description = "서브넷 CIDR 블록 목록"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# 게임 서버 설정 변수

variable "game_server_instance_type" {
  description = "게임 서버 EC2 인스턴스 유형"
  type        = string
  default     = "t3.medium"
}

variable "game_server_count" {
  description = "생성할 게임 서버 개수"
  type        = number
  default     = 1
}

variable "enable_monitoring" {
  description = "CloudWatch 상세 모니터링 활성화 여부"
  type        = bool
  default     = false
}

# 고급 구성 변수

variable "tags" {
  description = "모든 리소스에 적용할 태그"
  type        = map(string)
  default = {
    ManagedBy   = "Terraform"
    ServiceType = "GameServer"
  }
}
