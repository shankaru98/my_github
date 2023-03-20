terraform {
  required_version = "~>1.4.0"

  required_providers {
    aws ={
        version = ">=4.51.0"
    }
  }

  backend "s3" {
    bucket = "my-s3-terraform-backend-988646"
    key = "main/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
