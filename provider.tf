terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.97.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Source = "https://github.com/kunduso/aws-s3-sns-lambda-terraform"
    }
  }
}