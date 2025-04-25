# AWS 프로바이더 설정
# TODO: 리전을 ap-northeast-2로 수정해 주세요
provider "aws" {
  region = "us-east-1"  # 이 부분을 수정해야 합니다
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
