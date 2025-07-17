# face_detection_api/main.tf
locals {
  project     = "face-detection"
  environment = "test"
  suffix      = random_id.suffix.hex

  lambda_bucket = "fd-lambda-deploy-${local.suffix}"
  images_bucket = "fd-images-${local.suffix}"
}

resource "random_id" "suffix" {
  byte_length = 4
}
# S3 Bucket for Lambda Deployment
module "s3_deploy" {
  source      = "./modules/s3_deploy"
  bucket_name = local.lambda_bucket
  environment = local.environment
}
# IAM Role for Lambda
module "iam" {
  source             = "./modules/iam"
  iam_role_name      = "${local.project}-lambda-role"
  images_bucket_name = local.images_bucket
  iam_role_api_name  = "detect-faces-api"
}
# Lambda Function
module "lambda" {
  source         = "./modules/lambda"
  function_name  = "${local.project}-handler"
  lambda_handler = "detect_faces.lambda_handler"
  runtime        = "python3.13"
  iam_role_arn   = module.iam.lambda_role_arn
  s3_bucket      = module.s3_deploy.bucket_name
  s3_key         = "lambda_function.zip"

  environment_variables = {
    STAGE         = local.environment
    IMAGES_BUCKET = local.images_bucket
  }
}
# API Gateway HTTP API
module "api" {
  source              = "./modules/api"
  api_name            = "${local.project}-api"
  lambda_function_arn = module.lambda.lambda_function_arn
}
# Face Images Bucket with Lambda Trigger
module "s3_images" {
  source               = "./modules/s3_images"
  bucket_name          = local.images_bucket
  environment          = local.environment
  lambda_arn           = module.lambda.lambda_function_arn
  lambda_function_name = module.lambda.lambda_function_name
}

