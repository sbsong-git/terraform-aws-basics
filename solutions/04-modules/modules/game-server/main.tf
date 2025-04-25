# 게임 서버 EC2 인스턴스
resource "aws_instance" "game_server" {
  count = var.instance_count
  
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name
  iam_instance_profile   = var.instance_profile_name
  associate_public_ip_address = var.enable_public_ip
  monitoring             = var.enable_detailed_monitoring
  
  # 사용자 데이터 스크립트 (제공된 스크립트 또는 기본 스크립트)
  user_data = var.user_data_script != null ? var.user_data_script : <<-EOF
    #!/bin/bash
    
    # 시스템 업데이트
    yum update -y
    
    # 필요한 패키지 설치
    yum install -y amazon-cloudwatch-agent httpd
    
    # 서버 호스트명 설정
    hostnamectl set-hostname game-server-${count.index + 1}
    
    # 웹 서버 시작 (관리자 콘솔용)
    systemctl start httpd
    systemctl enable httpd
    
    # 관리 콘솔 페이지 생성
    cat > /var/www/html/index.html << 'HTMLEOF'
    <!DOCTYPE html>
    <html>
    <head>
      <title>Game Server ${count.index + 1} - ${var.environment}</title>
      <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        h1 { color: #333; }
        .status { padding: 10px; background-color: #dff0d8; border: 1px solid #d6e9c6; border-radius: 4px; }
      </style>
    </head>
    <body>
      <h1>Game Server ${count.index + 1} - ${var.environment}</h1>
      <div class="status">
        <p><strong>Status:</strong> Running</p>
        <p><strong>Environment:</strong> ${var.environment}</p>
        <p><strong>Instance Type:</strong> ${var.instance_type}</p>
        <p><strong>Region:</strong> ${var.region}</p>
      </div>
    </body>
    </html>
    HTMLEOF
    
    # 게임 서버 디렉토리 생성
    mkdir -p /opt/game-server
    
    # 간단한 게임 서버 상태 모니터링 스크립트
    cat > /opt/game-server/status.sh << 'SCRIPTEOF'
    #!/bin/bash
    
    while true; do
      echo "[$(date)] Game server is running..."
      sleep 60
    done
    SCRIPTEOF
    
    chmod +x /opt/game-server/status.sh
    
    # 게임 서버 로그 디렉토리 생성
    mkdir -p /var/log/game-server
    
    # 백그라운드에서 상태 모니터링 스크립트 실행
    nohup /opt/game-server/status.sh > /var/log/game-server/status.log 2>&1 &
    
    # 태그 메타데이터 표시
    echo "Environment: ${var.environment}" > /opt/game-server/metadata.txt
    echo "Project: ${var.project_name}" >> /opt/game-server/metadata.txt
  EOF
  
  # 루트 볼륨 설정
  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    delete_on_termination = true
    
    tags = merge(
      var.tags,
      {
        Name = "${var.project_name}-root-volume-${count.index + 1}-${var.environment}"
      }
    )
  }
  
  # 게임 데이터용 추가 볼륨
  ebs_block_device {
    device_name           = "/dev/sdf"
    volume_type           = "gp3"
    volume_size           = var.data_volume_size
    delete_on_termination = true
    
    tags = merge(
      var.tags,
      {
        Name = "${var.project_name}-game-data-volume-${count.index + 1}-${var.environment}"
      }
    )
  }
  
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-server-${count.index + 1}-${var.environment}"
    }
  )
}

# CloudWatch 로그 그룹 (게임 서버 로그용)
resource "aws_cloudwatch_log_group" "game_server_logs" {
  name              = "/aws/ec2/${var.project_name}-${var.environment}"
  retention_in_days = 7
  
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-logs-${var.environment}"
    }
  )
}

# 게임 에셋용 S3 버킷
resource "aws_s3_bucket" "game_assets" {
  bucket = "${var.project_name}-assets-${var.environment}-${random_string.bucket_suffix.result}"
  
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-assets-${var.environment}"
    }
  )
}

# 버킷 이름용 랜덤 문자열
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# S3 버킷 퍼블릭 액세스 차단 설정
resource "aws_s3_bucket_public_access_block" "game_assets" {
  bucket                  = aws_s3_bucket.game_assets.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 버전 관리 설정
resource "aws_s3_bucket_versioning" "game_assets" {
  bucket = aws_s3_bucket.game_assets.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 서버 상태 모니터링용 CloudWatch 알람
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  count               = var.instance_count
  alarm_name          = "${var.project_name}-cpu-alarm-${count.index + 1}-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "CPU 사용량이 80%를 초과할 경우 알람"
  
  dimensions = {
    InstanceId = aws_instance.game_server[count.index].id
  }
  
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-cpu-alarm-${count.index + 1}-${var.environment}"
    }
  )
}