#
# S3 bucket to store tfstate file
#
resource "aws_s3_bucket" "tf-state-bucket" {
  bucket     = var.BUCKET_NAME
  acl        = "private"
  tags       = var.TAGS
  versioning {
    enabled = true
  }
}