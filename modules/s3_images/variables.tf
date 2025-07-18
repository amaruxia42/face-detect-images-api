# face_detection_api/modules/s3_images/variables.tf
variable "bucket_name" {
  description = "S3 Image Bucket Name"
  type        = string
}

variable "environment" {
  description = "Enviroment variable"
  type        = string
}
variable "lambda_arn" {
  description = "Lambda ARN"
  type        = string
}
variable "lambda_function_name" {
  description = "Lambda function name"
  type        = string
}