terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "terraform-state-artems-task"
    key    = "project1/infrastructure.tfstate"
    region = "eu-central-1"
    dynamodb_table = "terraform-state-locking"
  }
}

provider "aws" {
    region = var.aws_region
}