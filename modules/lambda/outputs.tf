# /face_detection_api/modules/lambda/outputs.tf
output "lambda_function_arn" {
  value = aws_lambda_function.detect_faces.arn
}
output "lambda_function_name" {
  value = aws_lambda_function.detect_faces.function_name
}