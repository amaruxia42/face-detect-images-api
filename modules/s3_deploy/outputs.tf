# face_detection_api/modules/s3_deploy/outputs.tf
output "bucket_name" {
  value = aws_s3_bucket.deploy.id
}
