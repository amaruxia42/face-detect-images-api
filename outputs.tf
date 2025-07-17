# face_detection_api/outputs.tf
output "api_url" {
  description = "Base URL of the deployed API Gateway"
  value       = module.api.api_endpoint
}

output "lambda_function_name" {
  description = "Name of the deployed Lambda function"
  value       = module.lambda.lambda_function_name
}

output "lambda_function_arn" {
  description = "ARN of the deployed Lambda function"
  value       = module.lambda.lambda_function_arn
}

output "lambda_invoke_arn" {
  description = "Invoke ARN of the Lambda function (for permissions, triggers)"
  value       = module.lambda.lambda_function_arn
}

output "images_bucket_name" {
  description = "S3 bucket name for storing face detection images"
  value       = module.s3_deploy.bucket_name
}

output "iam_role_name" {
  description = "IAM role name used by the Lambda function"
  value       = module.iam.lambda_role_name
}