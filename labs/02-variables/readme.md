# 실습 2: 변수 활용

이 실습에서는 Terraform의 변수(Variables)와 출력(Outputs)을 활용하여 게임 서버 환경을 구성하는 방법을 배웁니다.

## 학습 목표

- 입력 변수 정의 및 활용
- 다양한 타입의 변수 사용 (문자열, 숫자, 리스트, 맵)
- 출력 변수 생성 및 활용
- 환경별 변수 파일(.tfvars) 관리

## 실습 단계

### 1. 파일 구조 살펴보기
현재 폴더에 다음 파일들이 있습니다:
- `main.tf`: 게임 서버 리소스 정의
- `variables.tf`: 입력 변수 정의 (일부 작성 필요)
- `outputs.tf`: 출력 변수 정의 (작성 필요)
- `dev.tfvars`: 개발 환경 변수 값
- `prod.tfvars`: 프로덕션 환경 변수 값
- `README.md`: 실습 안내

### 2. variables.tf 파일 완성하기
`variables.tf` 파일에 다음 변수 정의를 추가해 주세요:

- `game_server_instance_type`: 게임 서버 인스턴스 유형
  - 타입: 문자열
  - 설명: "게임 서버 EC2 인스턴스 유형"
  - 기본값: "t3.medium"

- `game_server_count`: 게임 서버 수량
  - 타입: 숫자
  - 설명: "생성할 게임 서버 개수"
  - 기본값: 1

- `enable_monitoring`: 모니터링 활성화 여부
  - 타입: 불리언
  - 설명: "CloudWatch 상세 모니터링 활성화 여부"
  - 기본값: false

### 3. outputs.tf 파일 작성하기
`outputs.tf` 파일을 생성하고 다음 출력 변수를 정의해 주세요:

- `vpc_id`: VPC ID 출력
- `game_server_security_group_id`: 게임 서버 보안 그룹 ID 출력
- `environment_summary`: 환경 요약 정보 출력 (문자열 결합 활용)

### 4. 환경별 변수 파일 살펴보기
`dev.tfvars`와 `prod.tfvars` 파일을 비교하여 환경별 차이점을 확인해 보세요.

### 5. Terraform 적용 (개발 환경)

```bash
# 초기화
terraform init

# 계획 검토 (개발 환경)
terraform plan -var-file=dev.tfvars

# 적용 (개발 환경)
terraform apply -var-file=dev.tfvars
```

### 6. 출력 값 확인

```bash
terraform output
```

### 7. 프로덕션 환경으로 전환

```bash
# 계획 검토 (프로덕션 환경)
terraform plan -var-file=prod.tfvars

# 필요시 적용 (프로덕션 환경)
# terraform apply -var-file=prod.tfvars
```

### 8. 리소스 삭제
실습이 끝나면 생성된 리소스를 삭제합니다:

```bash
terraform destroy -var-file=dev.tfvars
```

## 도전 과제 (선택사항)
- 새로운 변수 `backup_retention_days`를 추가하여 백업 보존 기간을 설정해 보세요.
- 리전별 AMI ID를 매핑하는 맵 변수를 만들어 보세요.
