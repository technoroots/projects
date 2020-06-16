resource "aws_s3_bucket" "terraform_state" {
  bucket = "mayank.4aug-bucket"
  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }
}


resource "aws_dynamodb_table" "terraform_locks" {
  name         = "mayank.4aug-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

