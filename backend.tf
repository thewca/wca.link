# Created by following the instructions on
# https://www.lightenna.com/tech/2018/storing-terraform-state-in-s3/ to set up an S3 backend
# for Terraform state.

# terraform state file setup
# create an S3 bucket to store the state file in
resource "aws_s3_bucket" "terraform-state-storage-s3" {
  bucket = "wca-terraform-state"

  versioning {
    # enable with caution, makes deleting S3 buckets tricky
    enabled = false
  }

  lifecycle {
    prevent_destroy = true
  }
}

# create a DynamoDB table for locking the state file
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = "wca-terraform-state-lock-dynamo"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    encrypt = true
    bucket = "wca-terraform-state"
    region = "us-west-2"
    dynamodb_table = "wca-terraform-state-lock-dynamo"
    key = "terraform-state/terraform.tfstate"
  }
}

