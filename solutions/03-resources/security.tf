# 게임 서버 보안 그룹
resource "aws_security_group" "game_server_sg" {
  name        = "${var.project_name}-sg-${var.environment}"
  description = "Security group for game servers"
  vpc_id      = aws_vpc.game_vpc.id
  
  # SSH 접속 허용
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # 실제 환경에서는 관리자 IP로 제한 권장
    description = "SSH access"
  }
  
  # HTTP 접속 허용 (관리 콘솔용)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access for admin console"
  }
  
  # 게임 서버 TCP 포트 허용
  ingress {
    from_port   = var.game_server_ports.from_port
    to_port     = var.game_server_ports.to_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Game server TCP traffic"
  }
  
  # 게임 서버 UDP 포트 허용
  ingress {
    from_port   = var.game_server_ports.from_port
    to_port     = var.game_server_ports.to_port
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Game server UDP traffic"
  }
  
  # 모든 아웃바운드 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
  
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-sg-${var.environment}"
    }
  )
}

# SSH 키 페어
resource "aws_key_pair" "game_server_key" {
  key_name   = "${var.project_name}-key-${var.environment}"
  public_key = file("${path.module}/ssh/game_server_key.pub")
  
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-key-${var.environment}"
    }
  )
}

# IAM 역할 (게임 서버가 필요한 AWS 서비스에 접근하기 위함)
resource "aws_iam_role" "game_server_role" {
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
resource "aws_iam_instance_profile" "game_server_profile" {
  name = "${var.project_name}-profile-${var.environment}"
  role = aws_iam_role.game_server_role.name
  
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-profile-${var.environment}"
    }
  )
}

# S3 접근 정책 (게임 에셋 등 저장)
resource "aws_iam_role_policy" "game_server_s3_policy" {
  name = "${var.project_name}-s3-policy-${var.environment}"
  role = aws_iam_role.game_server_role.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
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
resource "aws_iam_role_policy" "game_server_cloudwatch_policy" {
  name = "${var.project_name}-cloudwatch-policy-${var.environment}"
  role = aws_iam_role.game_server_role.id
  
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
