# /face_detection_api/modules/lambda/lambda.tf
# main.tf
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.root}/lambda/detect_faces.py"
  output_path = "${path.root}/face-detection-handler.zip"
}

resource "aws_s3_object" "upload" {
  bucket = var.s3_bucket
  key    = var.s3_key
  source = data.archive_file.lambda_zip.output_path
  etag   = data.archive_file.lambda_zip.output_base64sha256
}

resource "aws_lambda_function" "detect_faces" {
  function_name = var.function_name
  role          = var.iam_role_arn
  handler       = var.lambda_handler
  runtime       = var.runtime

  s3_bucket = var.s3_bucket
  s3_key    = var.s3_key

  memory_size = 256
  timeout     = 30

  environment {
    variables = var.environment_variables
  }
}

resource "aws_cloudwatch_log_group" "lambda_log" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 14
}





