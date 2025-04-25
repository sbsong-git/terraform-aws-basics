# 게임 서버 보안 그룹
resource "aws_security_group" "game_server" {
  name        = "${var.project_name}-sg-${var.environment}"
  description = "Security group for game servers"
  vpc_id      = var.vpc_id
  
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-sg-${var.environment}"
    }
  )
}

# SSH 인바운드 규칙
resource "aws_security_group_rule" "ssh_ingress" {
  count = var.enable_ssh ? 1 : 0
  
  security_group_id = aws_security_group.game_server.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.ssh_cidr_blocks
  description       = "SSH access"
}

# HTTP 인바운드 규칙 (관리 콘솔용)
resource "aws_security_group_rule" "http_ingress" {
  count = var.enable_http ? 1 : 0
  
  security_group_id = aws_security_group.game_server.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "HTTP access for admin console"
}

# 게임 서버 TCP 인바운드 규칙
resource "aws_security_group_rule" "game_tcp_ingress" {
  security_group_id = aws_security_group.game_server.id
  type              = "ingress"
  from_port         = var.game_server_ports.from_port
  to_port           = var.game_server_ports.to_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Game server TCP traffic"
}

# 게임 서버 UDP 인바운드 규칙
resource "aws_security_group_rule" "game_udp_ingress" {
  security_group_id = aws_security_group.game_server.id
  type              = "ingress"
  from_port         = var.game_server_ports.from_port
  to_port           = var.game_server_ports.to_port
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Game server UDP traffic"
}

# 모든 아웃바운드 규칙
resource "aws_security_group_rule" "all_egress" {
  security_group_id = aws_security_group.game_server.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic"
}

# VPC 내부 통신 규칙
resource "aws_security_group_rule" "internal_all" {
  security_group_id = aws_security_group.game_server.id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.vpc_cidr]
  description       = "Allow all internal VPC traffic"
}

# SSH 키 페어
resource "aws_key_pair" "game_server" {
  key_name   = "${var.project_name}-key-${var.environment}"
  public_key = file("${path.module}/${var.ssh_key_path}")
  
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-key-${var.environment}"
    }
  )
}

# IAM 역할 (게임 서버가 필요한 AWS 서비스에 접근하기 위함)
resource "aws_iam_role" "game_server" {
  name = "${var.project_name}-role-${var.environment}"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-role-${var.environment}"
    }
  )
}

# IAM 인스턴스 프로파일
resource "aws_iam_instance_profile" "game_server" {
  name = "${var.project_name}-profile-${var.environment}"
  role = aws_iam_role.game_server.name
  
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-profile-${var.environment}"
    }
  )
}

# S3 접근 정책 (게임 에셋 등 저장)
resource "aws_iam_role_policy" "s3_access" {
  name = "${var.project_name}-s3-policy-${var.environment}"
  role = aws_iam_role.game_server.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${var.project_name}-*",
          "arn:aws:s3:::${var.project_name}-*/*"
        ]
      }
    ]
  })
}

# CloudWatch 접근 정책 (로그 및 지표 수집)
resource "aws_iam_role_policy" "cloudwatch_access" {
  name = "${var.project_name}-cloudwatch-policy-${var.environment}"
  role = aws_iam_role.game_server.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "cloudwatch:PutMetricData",
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}