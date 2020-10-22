# backend

# terraform {
#   required_version = ">= 0.12"
#   backend "s3" {
#     region         = "ap-northeast-2"
#     bucket         = "terraform-workshop-082867736673"
#     key            = "db-demo.tfstate"
#     dynamodb_table = "terraform-resource-lock"
#     encrypt        = true
#   }
# }

# data "terraform_remote_state" "vpc" {
#   backend = "s3"
#   config = {
#     region = "ap-northeast-2"
#     bucket = "terraform-workshop-082867736673"
#     key    = "vpc-demo.tfstate"
#   }
# }

terraform {
  required_version = ">= 0.12"
  backend "remote" {
    organization = "bruce"
    workspaces {
      name = "db-demo"
    }
  }
}

data "terraform_remote_state" "vpc" {
  backend = "remote"
  config = {
    organization = "bruce"
    workspaces = {
      name = "vpc-demo"
    }
  }
}
