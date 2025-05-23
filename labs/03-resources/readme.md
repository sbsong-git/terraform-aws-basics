# 실습 3: AWS 리소스 구성

이 실습에서는 게임 서버를 위한 AWS 인프라 리소스를 구성하는 방법을 배웁니다.

## 학습 목표

- VPC, 서브넷, 라우팅 테이블 등 네트워크 리소스 구성
- 보안 그룹을 활용한 게임 서버 접근 제어
- EC2 인스턴스를 활용한 게임 서버 배포
- 리소스 간 종속성 관리

## 실습 단계

### 1. 파일 구조 살펴보기

현재 폴더에 다음 파일들이 있습니다:

- `main.tf`: 메인 구성 파일
- `variables.tf`: 변수 정의 파일
- `network.tf`: 네트워크 리소스 정의 (작성 필요)
- `security.tf`: 보안 관련 리소스 정의 (일부 작성 필요)
- `servers.tf`: 게임 서버 리소스 정의 (작성 필요)
- `terraform.tfvars`: 기본 변수 값
- `README.md`: 실습 안내

### 2. [network.tf](http://network.tf/) 파일 작성하기

네트워크 인프라를 구성하는 리소스를 정의해 주세요:

- VPC
- 퍼블릭/프라이빗 서브넷
- 인터넷 게이트웨이
- NAT 게이트웨이
- 라우팅 테이블

### 3. [security.tf](http://security.tf/) 파일 완성하기

보안 그룹에 다음 게임 서버 규칙을 추가해 주세요:

- TCP 포트 22 (SSH)
- TCP 포트 80 (HTTP - 관리 콘솔용)
- TCP/UDP 포트 7000-8000 (게임 트래픽)

### 4. [servers.tf](http://servers.tf/) 파일 작성하기

EC2 인스턴스를 생성하는 리소스를 정의해 주세요:

- 게임 서버용 EC2 인스턴스
- 서버 부팅 시 실행할 사용자 데이터 스크립트

### 5. SSH 키 파일 생성

```bash
cd terraform-aws-basics\labs\04-modules\modules\security

mkdir ssh

ssh-keygen -t rsa -b 2048 -f ssh/game_server_key
```

- 임의의 값을 입력하여 키 파일을 생성

### 6. Terraform 초기화 및 실행

```bash
# 초기화
terraform init

# 계획 검토
terraform plan

# 적용
terraform apply

```

### 7. 생성된 리소스 검증

AWS 콘솔에서 생성된 리소스를 확인하고, 게임 서버에 접속해 보세요.

### 8. 리소스 삭제

실습이 끝나면 생성된 리소스를 삭제합니다:

```bash
terraform destroy

```

## 도전 과제 (선택사항)

- 오토스케일링 그룹을 추가하여 게임 서버 자동 확장 구성하기
- CloudWatch 알람을 추가하여 서버 지표 모니터링하기
- 게임 서버 시작 시 필요한 소프트웨어를 설치하는 사용자 데이터 스크립트 개선하기
