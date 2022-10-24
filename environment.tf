// You should not have to change anything in this module. Just include it in your project directory
//
// This module will provide the following variables set for your region and environment
//
// module.environment.role_arn
// module.environment.account_id
// module.environment.vpc_id
// module.environment.private_subnets
// module.environment.public_subnets
//
// module.environment.github_owner
// module.environment.github_oauth_clone_token     - for Version 1 connections
// module.environment.github_oauth_package_token
// module.environment.github_connection            - for Version 2 connections

module "environment" {
  source = "git@github.com:CommissionsInc/terraform_modules.git//environment"

  environment = var.environment
  region      = var.region
}
