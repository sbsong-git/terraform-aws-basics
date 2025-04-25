# 게임 서버 모듈 출력값

output "instance_ids" {
  description = "게임 서버 인스턴스 ID 목록"
  value       = aws_instance.game_server[*].id
}

output "instance_private_ips" {
  description = "게임 서버 프라이빗 IP 목록"
  value       = aws_instance.game_server[*].private_ip
}

output "instance_public_ips" {
  description = "게임 서버 퍼블릭 IP 목록"
  value       = aws_instance.game_server[*].public_ip
}

output "instance_dns_names" {
  description = "게임 서버 DNS 이름 목록"
  value       = aws_instance.game_server[*].public_dns
}

output "assets_bucket_name" {
  description = "게임 에셋 버킷 이름"
  value       = aws_s3_bucket.game_assets.bucket
}

output "assets_bucket_arn" {
  description = "게임 에셋 버킷 ARN"
  value       = aws_s3_bucket.game_assets.arn
}

output "log_group_name" {
  description = "CloudWatch 로그 그룹 이름"
  value       = aws_cloudwatch_log_group.game_server_logs.name
}

output "instance_summary" {
  description = "게임 서버 요약 정보"
  value       = "${var.instance_count}대의 ${var.instance_type} 인스턴스가 ${var.environment} 환경에 배포됨"
}