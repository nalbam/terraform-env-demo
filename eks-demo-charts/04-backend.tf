# backend

# terraform {
#   required_version = ">= 0.12"
#   backend "s3" {
#     region         = "ap-northeast-2"
#     bucket         = "terraform-workshop-082867736673"
#     key            = "eks-demo-charts.tfstate"
#     dynamodb_table = "terraform-workshop-082867736673"
#     encrypt        = true
#   }
# }

# data "terraform_remote_state" "eks" {
#   backend = "s3"
#   config = {
#     region = "ap-northeast-2"
#     bucket = "terraform-workshop-082867736673"
#     key    = "eks-demo.tfstate"
#   }
# }

terraform {
  required_version = ">= 0.12"
  backend "remote" {
    organization = "bruce"
    workspaces {
      name = "eks-demo-charts"
    }
  }
}

data "terraform_remote_state" "eks" {
  backend = "remote"
  config = {
    organization = "bruce"
    workspaces = {
      name = "eks-demo"
    }
  }
}
