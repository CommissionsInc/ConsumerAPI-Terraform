module "route53_record" {
  source = "git@github.com:CommissionsInc/terraform_modules.git//route53_alias"

  domain_name   = "cincapi.com"
  record_name   = var.full_domain_name
  alias_target  = module.lambda.regional_domain_name
  alias_zone_id = module.lambda.regional_zone_id

  providers = { aws = aws.root }
}

module "security" {
  source = "git@github.com:CommissionsInc/terraform_modules.git//security"

  name             = var.name
  vpc_id           = module.environment.vpc_id
  allow_egress     = true
  allow_80         = true
  allow_public_80  = true
  allow_443        = true
  allow_public_443 = true
  tags             = var.tags
}

module "lambda" {
  source = "git@github.com:CommissionsInc/terraform_modules.git//lambda_rest_api_proxy"

  name                         = var.name
  owner                        = var.owner
  environment                  = var.environment
  description                  = var.description
  handler_function             = var.handler_function
  lambda_execution_role_arn    = aws_iam_role.lambda_execution_role.arn
  endpoint_type                = "REGIONAL"
  root_authorization           = "NONE"
  root_integration_type        = "AWS_PROXY"
  root_http_method             = "ANY"
  root_integration_http_method = "POST"
  proxy_authorization          = "NONE"
  proxy_api_key_required       = var.api_key_required
  environment_variables        = var.environment_variables
  domain_name                  = var.full_domain_name
  domain_name_certificate_arn  = module.ssl.arn
  set_custom_domain_name       = true
  vpc_id                       = module.environment.vpc_id
  subnet_ids                   = module.environment.private_subnets
  security_group_ids           = [module.security.security_group_id]
  tags                         = {}
}

resource "aws_iam_role" "lambda_execution_role" {
  name               = "${var.name}-${var.environment}-lambda-role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
         "Action": "sts:AssumeRole",
         "Principal": {
            "Service": "lambda.amazonaws.com"
         },
         "Effect": "Allow",
         "Sid": ""
      }
   ]
}
EOF
}

resource "aws_iam_policy_attachment" "attach_cloudwatch" {
  name       = "attach_cloudwatch"
  roles      = [aws_iam_role.lambda_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda-role-policy" {
  name = "${var.name}-${var.environment}-lambda-policy"
  role = aws_iam_role.lambda_execution_role.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DescribeLogStreams",
            "logs:GetLogEvents",
            "ec2:CreateNetworkInterface",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DeleteNetworkInterface"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}

module "ssl" {
  source = "git@github.com:CommissionsInc/terraform_modules.git//ssl_cert"

  name        = var.name
  environment = var.environment
  owner       = var.owner
  base_url    = var.base_domain_name
}

module "ssl_validation" {
  source = "git@github.com:CommissionsInc/terraform_modules.git//ssl_cert_validation"

  domain_name           = "cincapi.com"
  ssl_cert_record_name  = module.ssl.resource_record_name
  ssl_cert_record_value = module.ssl.resource_record_value
  providers             = { aws = aws.root }
}
