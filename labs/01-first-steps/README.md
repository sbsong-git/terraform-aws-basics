# 실습 1: 기본 설정 및 첫 리소스

이 실습에서는 Terraform 초기 설정 방법과 AWS S3 버킷을 생성하는 기본 단계를 배웁니다.

## 학습 목표

- Terraform 초기화 (init) 방법 이해
- AWS 프로바이더 구성하기
- 첫 번째 리소스(S3 버킷) 생성 및 관리

## 실습 단계

### 1. 파일 구조 살펴보기

현재 폴더에 다음 파일들이 있습니다:

- `main.tf`: 기본 설정 및 리소스 정의
- `providers.tf`: AWS 프로바이더 설정
- `README.md`: 실습 안내

### 2. [providers.tf](http://providers.tf/) 파일 완성하기

현재 `providers.tf` 파일에는 리전 설정이 누락되어 있습니다.
한국 리전(ap-northeast-2)을 사용하도록 수정해 보세요.

### 3. [main.tf](http://main.tf/) 파일 완성하기

S3 버킷 리소스가 일부 누락되어 있습니다.

- `acl` 속성을 `private`으로 설정해 주세요.
- `tags`를 추가하여 `Environment = "Dev"`, `Service = "GameAssets"`로 설정해 주세요.

### 4. Terraform 초기화 및 적용

```bash
# 초기화
terraform init

# 계획 검토
terraform plan

# 적용
terraform apply

```

### 5. 생성된 S3 버킷 확인

AWS 콘솔에서 생성된 S3 버킷을 확인해 보세요.

### 6. 리소스 삭제

실습이 끝나면 생성된 리소스를 삭제합니다:

```bash
terraform destroy

```

## 도전 과제 (선택사항)

- 버킷 이름을 본인의 이름이나 팀 이름을 포함하도록 수정해 보세요.
- 버킷에 버전 관리 기능을 활성화해 보세요.
