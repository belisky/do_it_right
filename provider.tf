terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.74"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    bucket = "nobel-tf-state-bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}



provider "aws" {
  region = "us-east-1"
}

