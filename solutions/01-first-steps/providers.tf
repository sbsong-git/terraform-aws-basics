# AWS 프로바이더 설정
provider "aws" {
  region = "ap-northeast-2"  # 서울 리전
}

# Terraform 버전 및 프로바이더 요구사항 설정
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 0.14"
}
