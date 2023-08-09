terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>3.0"
    }
  }
}


provider "aws" {
    region = "eu-central-1"
}

resource "aws_s3_bucket" "terraform_state" {
    bucket = "terraform-state-artems-task"
    lifecycle {
      prevent_destroy = true
    }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
    name = "terraform-state-locking"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
      name = "LockID"
      type = "S"
    }
  
}