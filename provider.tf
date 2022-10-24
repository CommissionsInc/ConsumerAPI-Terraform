// You should not have to change anything in this 
// module. Just include it in your project directory

provider "aws" {
  region = var.region
  assume_role {
    role_arn = module.environment.role_arn
  }
  default_tags {
    tags = {
      Environment = var.environment
      Owner       = var.owner
      Project     = var.project
      Created_By  = "Terraform"
    }
  }
}

provider "aws" {
  alias  = "root"
  region = var.region
}


// These are the minimum variables required. You must set values for all of these
// in your .tfvars file. 

variable "environment" {
  description = "The environment to run in (must be dev or sandbox, uat, or prod)"
  type        = string
}

variable "owner" {
  description = "The team responsible for the project"
  type        = string
}

variable "project" {
  description = "The name of the project (will be used in naming components and so may not contain spaces and must be lower case)"
  type        = string
}

variable "region" {
  description = "The aws region to deploy into"
  type        = string
  default     = "us-east-2"
}
