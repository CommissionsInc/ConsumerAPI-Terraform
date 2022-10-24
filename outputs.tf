// Lambda Outputs
output "lambda_arn" {
  value = module.lambda.lambda_arn
}

output "invoke_arn" {
  value = module.lambda.lambda_invoke_arn
}

output "api_url" {
  value = module.lambda.base_url
}

output "lambda_name" {
  value = module.lambda.name
}

output "lambda_regional_domain_name" {
  value = module.lambda.regional_domain_name
}

output "lambda_regional_zone_id" {
  value = module.lambda.regional_zone_id
}

output "ssl_arn" {
  value = module.ssl.arn
}