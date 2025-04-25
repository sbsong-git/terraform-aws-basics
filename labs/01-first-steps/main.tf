# 게임 에셋 저장용 S3 버킷 생성
resource "aws_s3_bucket" "game_assets" {
  bucket = "game-assets-bucket-${random_string.bucket_suffix.result}"
  
  # TODO: acl을 private으로 설정해 주세요
  
  # TODO: 태그를 추가해 주세요 (Environment = "Dev", Service = "GameAssets")
}

# 버킷 이름에 사용할 랜덤 문자열 생성
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# 추가: S3 버킷 소유권 설정
resource "aws_s3_bucket_ownership_controls" "game_assets" {
  bucket = aws_s3_bucket.game_assets.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# 추가: S3 퍼블릭 액세스 차단 설정
resource "aws_s3_bucket_public_access_block" "game_assets" {
  bucket                  = aws_s3_bucket.game_assets.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
