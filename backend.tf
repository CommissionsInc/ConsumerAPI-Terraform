terraform {
  backend "s3" {
//    bucket = "cinc-us-east-2-tfstate-sandbox"
    bucket   = "cinc-us-east-2-tfstate-uat"
//    bucket   = "cinc-us-east-2-tfstate-production
    key      = "consumer-api-terraform/terraform.tfstate"
    region   = "us-east-2"
//    role_arn = "arn:aws:iam::197848513456:role/sandbox-administrator"
    role_arn = "arn:aws:iam::298470299831:role/ops-development-administrator"
//    role_arn = "arn:aws:iam::357890849873:role/ops-api-production-administrators"
  }
}
