resource "aws_s3_bucket" "tf_state" {
  bucket = "terraform-state-640706953781-gasagent2"
  force_destroy = true
  tags = {
    Name = "tf-state-bucket"
  }
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name = "tf-state-lock"
  }
}
