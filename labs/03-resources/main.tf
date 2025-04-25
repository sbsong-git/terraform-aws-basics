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

# 출력값 정의
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.game_vpc.id
}

output "public_subnet_ids" {
  description = "퍼블릭 서브넷 ID 목록"
  value       = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  description = "프라이빗 서브넷 ID 목록"
  value       = aws_subnet.private_subnet[*].id
}

output "game_server_public_ips" {
  description = "게임 서버 퍼블릭 IP 목록"
  value       = aws_instance.game_server[*].public_ip
}

output "game_server_security_group_id" {
  description = "게임 서버 보안 그룹 ID"
  value       = aws_security_group.game_server_sg.id
}
