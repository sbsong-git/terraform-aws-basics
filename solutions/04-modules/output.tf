# 네트워크 관련 출력값
output "vpc_id" {
  description = "VPC ID"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "퍼블릭 서브넷 ID 목록"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "프라이빗 서브넷 ID 목록"
  value       = module.network.private_subnet_ids
}

# 보안 관련 출력값
output "security_group_id" {
  description = "게임 서버 보안 그룹 ID"
  value       = module.security.security_group_id
}

output "ssh_key_name" {
  description = "SSH 키 페어 이름"
  value       = module.security.ssh_key_name
}

# 게임 서버 관련 출력값
output "instance_ids" {
  description = "게임 서버 인스턴스 ID 목록"
  value       = module.game_server.instance_ids
}

output "instance_public_ips" {
  description = "게임 서버 퍼블릭 IP 목록"
  value       = module.game_server.instance_public_ips
}

output "instance_private_ips" {
  description = "게임 서버 프라이빗 IP 목록"
  value       = module.game_server.instance_private_ips
}

output "assets_bucket_name" {
  description = "게임 에셋 버킷 이름"
  value       = module.game_server.assets_bucket_name
}

# 종합 정보
output "environment_info" {
  description = "환경 정보 요약"
  value       = "환경: ${var.environment}, 리전: ${var.region}, 프로젝트: ${var.project_name}"
}

output "server_info" {
  description = "서버 정보 요약"
  value       = module.game_server.instance_summary
}

output "connection_info" {
  description = "서버 접속 정보"
  value       = [
    for i, ip in module.game_server.instance_public_ips : 
    "게임 서버 ${i+1} 접속: ssh -i ssh/game_server_key ec2-user@${ip}"
  ]
}