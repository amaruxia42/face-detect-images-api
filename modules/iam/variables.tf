# variables.tf
variable "iam_role_name" {
  description = "IAM role for S3"
  type        = string
}
variable "images_bucket_name" {
  type = string
}

variable "iam_role_api_name" {
  description = "IAM role for API Gateway"
  type        = string
}