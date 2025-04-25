# VPC ID 출력
output "vpc_id" {
  description = "생성된 VPC의 ID"
  value       = aws_vpc.game_server_vpc.id
}

# 게임 서버 보안 그룹 ID 출력
output "game_server_security_group_id" {
  description = "게임 서버 보안 그룹 ID"
  value       = aws_security_group.game_server_sg.id
}

# 환경 요약 정보 출력
output "environment_summary" {
  description = "환경 구성 요약 정보"
  value       = "${var.environment} 환경의 게임 서버 구성: ${var.game_server_count}대의 ${var.game_server_instance_type} 인스턴스, 모니터링 ${var.enable_monitoring ? "활성화" : "비활성화"}"
}

# S3 버킷 정보 출력
output "game_assets_bucket" {
  description = "게임 에셋 저장용 S3 버킷 이름"
  value       = aws_s3_bucket.game_assets.bucket
}

# 서브넷 ID 목록 출력
output "subnet_ids" {
  description = "생성된 서브넷 ID 목록"
  value       = aws_subnet.game_server_subnet[*].id
}
