# 보안 모듈 입력 변수

variable "region" {
  description = "AWS 리전"
  type        = string
}

variable "project_name" {
  description = "프로젝트 이름"
  type        = string
}

variable "environment" {
  description = "환경 (dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR 블록"
  type        = string
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

variable "enable_ssh" {
  description = "SSH 접속 허용 여부"
  type        = bool
  default     = true
}

variable "enable_http" {
  description = "HTTP 접속 허용 여부"
  type        = bool
  default     = true
}

variable "ssh_cidr_blocks" {
  description = "SSH 접속을 허용할 CIDR 블록 목록"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "모든 리소스에 적용할 태그"
  type        = map(string)
  default     = {}
}

variable "ssh_key_path" {
  description = "SSH 공개 키 경로"
  type        = string
  default     = "ssh/game_server_key.pub"
}