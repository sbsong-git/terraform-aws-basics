# 보안 모듈 출력값

output "security_group_id" {
  description = "게임 서버 보안 그룹 ID"
  value       = aws_security_group.game_server.id
}

output "security_group_name" {
  description = "게임 서버 보안 그룹 이름"
  value       = aws_security_group.game_server.name
}

output "ssh_key_name" {
  description = "게임 서버 SSH 키 페어 이름"
  value       = aws_key_pair.game_server.key_name
}

output "iam_role_arn" {
  description = "게임 서버 IAM 역할 ARN"
  value       = aws_iam_role.game_server.arn
}

output "iam_role_name" {
  description = "게임 서버 IAM 역할 이름"
  value       = aws_iam_role.game_server.name
}

output "instance_profile_name" {
  description = "게임 서버 인스턴스 프로파일 이름"
  value       = aws_iam_instance_profile.game_server.name
}

output "instance_profile_arn" {
  description = "게임 서버 인스턴스 프로파일 ARN"
  value       = aws_iam_instance_profile.game_server.arn
}