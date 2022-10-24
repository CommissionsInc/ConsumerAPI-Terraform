module "codepipeline" {
  source = "git@github.com:CommissionsInc/terraform_modules.git//codepipeline_codebuild_lambda"

  project             = var.project
  environment         = var.environment
  owner               = module.environment.github_owner
  region              = var.region
  account_id          = module.environment.account_id
  github_oauth_token  = module.environment.github_oauth_clone_token
  github_repo         = var.github_project_name
  github_branch       = var.repo_branch
  solution_file       = var.solution_file
  lambda_name         = module.lambda.name
  github_version      = 2
  codestar_connection = module.environment.github_connection
  tags                = {}
}
