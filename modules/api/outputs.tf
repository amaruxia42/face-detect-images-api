# face_detection_api/modules/api/outputs.tf
output "api_id" {
  description = "ID of the API Gateway"
  value       = aws_apigatewayv2_api.api.id
}

output "api_endpoint" {
  description = "Base endpoint URL of the API"
  value       = aws_apigatewayv2_api.api.api_endpoint
}

output "api_execution_arn" {
  description = "Execution ARN of the API Gateway"
  value       = aws_apigatewayv2_api.api.execution_arn
}