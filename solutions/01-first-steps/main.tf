# 게임 에셋 저장용 S3 버킷 생성
resource "aws_s3_bucket" "game_assets" {
  bucket = "game-assets-bucket-${random_string.bucket_suffix.result}"
  
  # acl 설정 (private)
  # 참고: AWS S3는 최신 버전에서 별도 리소스로 분리되었습니다
  
  tags = {
    Environment = "Dev"
    Service     = "GameAssets"
  }
}

# ACL 설정 분리
resource "aws_s3_bucket_acl" "game_assets_acl" {
  bucket = aws_s3_bucket.game_assets.id
  acl    = "private"
  depends_on = [aws_s3_bucket_ownership_controls.game_assets]
}

# 버킷 이름에 사용할 랜덤 문자열 생성
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# S3 버킷 소유권 설정
resource "aws_s3_bucket_ownership_controls" "game_assets" {
  bucket = aws_s3_bucket.game_assets.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# S3 퍼블릭 액세스 차단 설정
resource "aws_s3_bucket_public_access_block" "game_assets" {
  bucket                  = aws_s3_bucket.game_assets.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
