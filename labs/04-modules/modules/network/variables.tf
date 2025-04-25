# 네트워크 모듈 입력 변수

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

variable "vpc_cidr" {
  description = "VPC CIDR 블록"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "퍼블릭 서브넷 CIDR 블록 목록"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "프라이빗 서브넷 CIDR 블록 목록"
  type        = list(string)
}

variable "tags" {
  description = "모든 리소스에 적용할 태그"
  type        = map(string)
  default     = {}
}

variable "enable_nat_gateway" {
  description = "NAT 게이트웨이 활성화 여부"
  type        = bool
  default     = true
}

variable "one_nat_gateway_per_az" {
  description = "가용 영역마다 NAT 게이트웨이 생성 여부"
  type        = bool
  default     = false
}
