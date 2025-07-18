# face_detection_api/modules/api/variables.tf
variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
}

variable "lambda_function_arn" {
  description = "ARN of the Lambda function to integrate"
  type        = string
}