# face_detection_api/modules/s3_images/images.tf
resource "aws_s3_bucket" "images" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3ToInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.images.arn
}

resource "aws_s3_bucket_notification" "notify_lambda" {
  bucket = aws_s3_bucket.images.id

  lambda_function {
    lambda_function_arn = var.lambda_arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}

resource "aws_s3_bucket_public_access_block" "images" {
  bucket = aws_s3_bucket.images.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "images" {
  bucket = aws_s3_bucket.images.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "images" {
  bucket = aws_s3_bucket.images.id

  versioning_configuration {
    status = "Enabled"
  }
}

