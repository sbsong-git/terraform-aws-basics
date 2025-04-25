# 게임 서버 모듈 입력 변수

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

variable "subnet_ids" {
  description = "게임 서버를 배포할 서브넷 ID 목록"
  type        = list(string)
}

variable "security_group_id" {
  description = "게임 서버 보안 그룹 ID"
  type        = string
}

variable "key_name" {
  description = "SSH 키 페어 이름"
  type        = string
}

variable "instance_profile_name" {
  description = "인스턴스 프로파일 이름"
  type        = string
}

variable "instance_type" {
  description = "게임 서버 인스턴스 타입"
  type        = string
  default     = "t3.medium"
}

variable "ami_id" {
  description = "게임 서버 AMI ID"
  type        = string
  default     = "ami-0c6e5afdd23291f73"  # Amazon Linux 2 (서울 리전)
}

variable "instance_count" {
  description = "생성할 게임 서버 인스턴스 수"
  type        = number
  default     = 1
}

variable "enable_detailed_monitoring" {
  description = "EC2 상세 모니터링 활성화 여부"
  type        = bool
  default     = false
}

variable "root_volume_size" {
  description = "루트 볼륨 크기 (GB)"
  type        = number
  default     = 20
}

variable "data_volume_size" {
  description = "데이터 볼륨 크기 (GB)"
  type        = number
  default     = 50
}

variable "enable_public_ip" {
  description = "퍼블릭 IP 할당 여부"
  type        = bool
  default     = true
}

variable "tags" {
  description = "모든 리소스에 적용할 태그"
  type        = map(string)
  default     = {}
}

variable "user_data_script" {
  description = "사용자 데이터 스크립트 (기본 스크립트 사용 시 null)"
  type        = string
  default     = null
}