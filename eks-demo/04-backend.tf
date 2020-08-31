# backend

# terraform {
#   backend "s3" {
#     region         = "ap-northeast-2"
#     bucket         = "terraform-workshop-082867736673"
#     key            = "eks-demo.tfstate"
#     dynamodb_table = "terraform-workshop-082867736673"
#     encrypt        = true
#   }
#   required_version = ">= 0.12"
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
  backend "remote" {
    organization = "bruce"
    workspaces {
      name = "eks-demo"
    }
  }
  required_version = ">= 0.12"
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
