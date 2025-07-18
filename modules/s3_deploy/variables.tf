# face_detection_api/modules/s3/variables.tf
# variables.tf
variable "bucket_name" {
  description = "S3 Bucket Name for deployment"
  type        = string
}

variable "environment" {
  description = "Enviroment variables"
  type        = string
}


