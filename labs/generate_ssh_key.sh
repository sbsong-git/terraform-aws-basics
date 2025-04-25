#!/bin/bash

# 스크립트 설명
echo "게임 서버 SSH 키 생성 스크립트"
echo "이 스크립트는 각 실습 디렉토리에 SSH 키를 생성합니다."
echo ""

# 기본 변수 설정
KEY_NAME="game_server_key"
LABS_DIRS=("01-first-steps" "02-variables" "03-resources" "04-modules")

# 현재 디렉토리 확인
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

generate_key() {
    local lab_dir=$1
    local key_dir="${SCRIPT_DIR}/${lab_dir}/ssh"
    local key_path="${key_dir}/${KEY_NAME}"
    
    # SSH 디렉토리 생성
    mkdir -p "${key_dir}"
    
    # 키가 이미 존재하는지 확인
    if [ -f "${key_path}" ]; then
        echo "경고: ${lab_dir} 디렉토리에 키가 이미 존재합니다. 덮어쓰려면 기존 키를 먼저 삭제해 주세요."
        return
    fi
    
    # SSH 키 생성
    echo "- ${lab_dir} 디렉토리의 SSH 키 생성 중..."
    ssh-keygen -t rsa -b 2048 -f "${key_path}" -N "" -C "terraform-aws-basics-${lab_dir}"
    
    # 솔루션 디렉토리에도 복사
    local solution_key_dir="${SCRIPT_DIR}/../solutions/${lab_dir}/ssh"
    mkdir -p "${solution_key_dir}"
    cp "${key_path}" "${solution_key_dir}/"
    cp "${key_path}.pub" "${solution_key_dir}/"
    
    echo "  키 생성 완료: ${key_path}"
}

# 메인 로직
echo "SSH 키 생성을 시작합니다..."

for lab in "${LABS_DIRS[@]}"; do
    generate_key "$lab"
done

echo ""
echo "모든 SSH 키 생성이 완료되었습니다."
echo "중요: 실습이 끝난 후에는 보안을 위해 생성된 키를 삭제해 주세요."