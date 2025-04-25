# 게임 서버 보안 그룹
resource "aws_security_group" "game_server_sg" {
  name        = "${var.project_name}-sg-${var.environment}"
  description = "Security group for game servers"
  vpc_id      = aws_vpc.game_vpc.id
  
  # TODO: 다음 인바운드 규칙을 추가해 주세요:
  # - TCP 포트 22 (SSH)
  # - TCP 포트 80 (HTTP - 관리 콘솔용)
  # - TCP/UDP 포트 7000-8000 (게임 트래픽)
  
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
