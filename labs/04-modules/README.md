# 실습 4: 모듈 활용

이 실습에서는 Terraform 모듈을 활용하여 재사용 가능한 게임 서버 인프라를 구성하는 방법을 배웁니다.

## 학습 목표

- Terraform 모듈의 개념 이해
- 재사용 가능한 모듈 작성 방법
- 모듈 매개변수와 출력 값 활용
- 여러 환경에서 모듈 재사용

## 실습 단계

### 1. 파일 구조 살펴보기

현재 폴더에 다음 파일들과 디렉토리가 있습니다:

- `main.tf`: 메인 구성 파일 (루트 모듈)
- `variables.tf`: 변수 정의 파일
- `outputs.tf`: 출력 값 정의 파일
- `terraform.tfvars`: 변수 값 설정 파일
- `modules/`: 모듈 디렉토리
    - `network/`: 네트워크 모듈 (완성됨)
    - `security/`: 보안 모듈 (작성 필요)
    - `game-server/`: 게임 서버 모듈 (작성 필요)

### 2. Security 모듈 작성

`modules/security/` 디렉토리에 다음 파일들을 작성해 주세요:

- `variables.tf`: 입력 변수 정의
- `main.tf`: 보안 그룹 및 IAM 정책 정의
- `outputs.tf`: 출력 값 정의

### 3. Game Server 모듈 작성

`modules/game-server/` 디렉토리에 다음 파일들을 작성해 주세요:

- `variables.tf`: 입력 변수 정의
- `main.tf`: EC2 인스턴스 및 관련 리소스 정의
- `outputs.tf`: 출력 값 정의

### 4. 루트 모듈 완성하기

`main.tf` 파일에서 모듈을 호출하는 부분을 완성해 주세요:

- Network 모듈 호출
- Security 모듈 호출
- Game Server 모듈 호출

### 5. Terraform 초기화 및 실행

```bash
# 초기화
terraform init

# 계획 검토
terraform plan

# 적용
terraform apply

```

### 6. 다른 환경 설정 추가

`environments/` 폴더에 `dev.tfvars`와 `prod.tfvars` 파일을 작성해 주세요:

- 개발 환경 설정
- 프로덕션 환경 설정

### 7. 여러 환경에 적용 테스트

```bash
# 개발 환경 적용
terraform apply -var-file=environments/dev.tfvars

# 프로덕션 환경 계획 검토
terraform plan -var-file=environments/prod.tfvars

```

### 8. 리소스 삭제

실습이 끝나면 생성된 리소스를 삭제합니다:

```bash
terraform destroy

```

## 도전 과제 (선택사항)

- 데이터베이스 모듈을 추가하여 게임 데이터 저장 인프라 구성하기
- 모니터링 모듈을 추가하여 CloudWatch 알람 및 대시보드 구성하기
- 스케일링 정책을 적용한 오토스케일링 그룹 모듈 작성하기
