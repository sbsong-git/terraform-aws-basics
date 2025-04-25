# Terraform AWS 기초 실습

게임 개발을 위한 AWS 인프라 관리 Terraform 실습 자료입니다.

## 개요

이 저장소는 게임 개발자와 인프라 담당자를 위한 Terraform 기초 교육 실습 자료를 포함하고 있습니다. 
게임 서비스에 적합한 AWS 인프라 구성 방법과 IaC(Infrastructure as Code) 관리 방법을 학습할 수 있습니다.

## 사전 요구사항

- AWS 계정
- AWS CLI 설치 및 구성 완료
- Terraform 0.14 이상 설치
- Git 클라이언트

## 실습 구성

4개의 단계별 실습으로 구성되어 있습니다:

1. **기본 설정과 첫 리소스 (labs/01-first-steps)**
   - AWS Provider 설정
   - S3 버킷 생성하기

2. **변수 활용 (labs/02-variables)**
   - 입력 변수 정의와 활용
   - 출력 변수 정의와 활용

3. **AWS 리소스 구성 (labs/03-resources)**
   - VPC 및 서브넷 구성
   - EC2 인스턴스와 보안 그룹 생성

4. **모듈 활용 (labs/04-modules)**
   - 재사용 가능한 모듈 생성
   - 게임 서버 인프라 모듈화

## 사용 방법

각 실습 폴더에 있는 지시사항을 따라 진행해 주세요:

```bash
# 저장소 클론
git clone https://github.com/sagawa8b/terraform-aws-basics.git
cd terraform-aws-basics

# 실습 디렉토리로 이동
cd labs/01-first-steps

# 실습 진행
terraform init
terraform plan
terraform apply
```

## 주의사항

- 실습 완료 후 반드시 생성한 리소스를 삭제해 주세요:
```bash
terraform destroy
```
- AWS 프리 티어를 넘어가는 리소스가 생성될 수 있으니 비용에 주의하세요.

## 라이센스

MIT License
