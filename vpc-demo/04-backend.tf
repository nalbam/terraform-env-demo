# backend

# terraform {
#   backend "s3" {
#     region         = "ap-northeast-2"
#     bucket         = "terraform-workshop-082867736673"
#     key            = "vpc-demo.tfstate"
#     dynamodb_table = "terraform-workshop-082867736673"
#     encrypt        = true
#   }
#   required_version = ">= 0.12"
# }

terraform {
  backend "remote" {
    organization = "bruce"
    workspaces {
      name = "vpc-demo"
    }
  }
  required_version = ">= 0.12"
}
