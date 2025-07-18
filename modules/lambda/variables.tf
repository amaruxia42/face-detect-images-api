# /face_detection_api/modules/lambda/variables.tf
variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "lambda_handler" {
  description = "Lambda function handler"
  type        = string
}

variable "runtime" {
  description = "Lambda runtime python3.13"
  type        = string
}

variable "iam_role_arn" {
  description = "IAM role ARN for Lambda"
  type        = string
}

variable "s3_bucket" {
  description = "S3 bucket for Lambda deployment"
  type        = string
}

variable "s3_key" {
  description = "S3 key for the Lambda deployment package"
  type        = string
}

variable "environment_variables" {
  description = "Environment variables for Lambda"
  type        = map(string)
  default     = {}
}