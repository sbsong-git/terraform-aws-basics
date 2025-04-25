# 기본 설정 변수
variable "region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "project_name" {
  description = "프로젝트 이름"
  type        = string
  default     = "game-server"
}

variable "environment" {
  description = "환경 (dev, staging, prod)"
  type        = string
  default     = "dev"
}

# 네트워크 설정
variable "vpc_cidr" {
  description = "VPC CIDR 블록"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "퍼블릭 서브넷 CIDR 블록 목록"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "프라이빗 서브넷 CIDR 블록 목록"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

# 게임 서버 설정
variable "game_server_count" {
  description = "게임 서버 인스턴스 수"
  type        = number
  default     = 1
}

variable "game_server_instance_type" {
  description = "게임 서버 인스턴스 타입"
  type        = string
  default     = "t3.medium"
}

variable "game_server_ports" {
  description = "게임 서버 TCP/UDP 포트 범위"
  type        = object({
    from_port = number
    to_port   = number
  })
  default = {
    from_port = 7000
    to_port   = 8000
  }
}

# AMI 설정
variable "ami_id" {
  description = "게임 서버 AMI ID"
  type        = string
  default     = "ami-0c6e5afdd23291f73"  # Amazon Linux 2 (서울 리전)
}

# 태그
variable "tags" {
  description = "모든 리소스에 적용할 태그"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Project   = "GameServer"
  }
}

# 백업 설정
variable "enable_backups" {
  description = "백업 활성화 여부"
  type        = bool
  default     = true
}

# 모니터링 설정
variable "enable_detailed_monitoring" {
  description = "EC2 상세 모니터링 활성화 여부"
  type        = bool
  default     = false
}
