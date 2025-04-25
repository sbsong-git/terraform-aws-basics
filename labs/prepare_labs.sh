#!/bin/bash

# 스크립트 설명
echo "Terraform AWS 기초 실습 준비 스크립트"
echo "이 스크립트는 실습 환경을 준비합니다."
echo ""

# 현재 디렉토리 확인
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# 기본 디렉토리 구조 생성
create_directory_structure() {
    echo "기본 디렉토리 구조를 생성합니다..."
    
    # 메인 디렉토리
    mkdir -p "${SCRIPT_DIR}/labs"
    mkdir -p "${SCRIPT_DIR}/solutions"
    mkdir -p "${SCRIPT_DIR}/modules"
    mkdir -p "${SCRIPT_DIR}/examples"
    
    # 실습 디렉토리
    mkdir -p "${SCRIPT_DIR}/labs/01-first-steps"
    mkdir -p "${SCRIPT_DIR}/labs/02-variables"
    mkdir -p "${SCRIPT_DIR}/labs/03-resources"
    mkdir -p "${SCRIPT_DIR}/labs/04-modules"
    
    # 모듈 디렉토리
    mkdir -p "${SCRIPT_DIR}/labs/04-modules/modules/network"
    mkdir -p "${SCRIPT_DIR}/labs/04-modules/modules/security"
    mkdir -p "${SCRIPT_DIR}/labs/04-modules/modules/game-server"
    
    # 환경 디렉토리
    mkdir -p "${SCRIPT_DIR}/labs/04-modules/environments"
    
    # 솔루션 디렉토리
    mkdir -p "${SCRIPT_DIR}/solutions/01-first-steps"
    mkdir -p "${SCRIPT_DIR}/solutions/02-variables"
    mkdir -p "${SCRIPT_DIR}/solutions/03-resources"
    mkdir -p "${SCRIPT_DIR}/solutions/04-modules"
    
    echo "디렉토리 구조 생성 완료!"
}

# AWS 구성 확인
check_aws_config() {
    echo "AWS 구성을 확인합니다..."
    
    if ! command -v aws &> /dev/null; then
        echo "오류: AWS CLI가 설치되어 있지 않습니다. 설치 후 다시 시도해 주세요."
        echo "설치 방법: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
        return 1
    fi
    
    if ! aws sts get-caller-identity &> /dev/null; then
        echo "오류: AWS 계정에 접근할 수 없습니다. AWS 자격 증명을 구성해 주세요."
        echo "구성 방법: aws configure"
        return 1
    fi
    
    echo "AWS 구성이 정상적으로 확인되었습니다!"
    return 0
}

# Terraform 설치 확인
check_terraform() {
    echo "Terraform 설치를 확인합니다..."
    
    if ! command -v terraform &> /dev/null; then
        echo "오류: Terraform이 설치되어 있지 않습니다. 설치 후 다시 시도해 주세요."
        echo "설치 방법: https://learn.hashicorp.com/tutorials/terraform/install-cli"
        return 1
    fi
    
    local tf_version=$(terraform --version | head -n 1 | cut -d 'v' -f 2)
    local min_version="0.14.0"
    
    if [[ "$(printf '%s\n' "$min_version" "$tf_version" | sort -V | head -n1)" != "$min_version" ]]; then
        echo "오류: Terraform 버전이 너무 낮습니다. v${min_version} 이상이 필요합니다."
        echo "현재 버전: v${tf_version}"
        return 1
    fi
    
    echo "Terraform 설치가 정상적으로 확인되었습니다! (v${tf_version})"
    return 0
}

# 실습 파일 복사
# 참고: 실제 구현에서는 이 부분에 코드를 넣어 실습 파일을 복사합니다.

# 메인 로직
echo "실습 환경 준비를 시작합니다..."

# 디렉토리 구조 생성
create_directory_structure

# AWS 구성 확인
if ! check_aws_config; then
    echo "경고: AWS 구성에 문제가 있습니다. 실습을 진행하기 전에 해결해 주세요."
fi

# Terraform 설치 확인
if ! check_terraform; then
    echo "경고: Terraform 설치에 문제가 있습니다. 실습을 진행하기 전에 해결해 주세요."
fi

# SSH 키 생성 스크립트 실행
echo "SSH 키를 생성합니다..."
bash "${SCRIPT_DIR}/labs/generate_ssh_key.sh"

echo ""
echo "실습 환경 준비가 완료되었습니다."
echo "시작하려면 labs/01-first-steps 디렉토리로 이동하세요:"
echo "cd ${SCRIPT_DIR}/labs/01-first-steps"