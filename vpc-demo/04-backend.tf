# backend

# terraform {
#   required_version = ">= 0.12"
#   backend "s3" {
#     region         = "ap-northeast-2"
#     bucket         = "terraform-workshop-082867736673"
#     key            = "vpc-demo.tfstate"
#     dynamodb_table = "terraform-workshop-082867736673"
#     encrypt        = true
#   }
# }

terraform {
  required_version = ">= 0.12"
  backend "remote" {
    organization = "bruce"
    workspaces {
      name = "vpc-demo"
    }
  }
}
