data "aws_s3_bucket" "existing" {
  bucket = "terraform-state-640706953781-gasagent2"
  count  = 0 # always 0, just for reference
}

resource "aws_s3_bucket" "tf_state" {
  bucket = "terraform-state-640706953781-gasagent2"
  force_destroy = true
  tags = {
    Name = "tf-state-bucket"
  }
  lifecycle {
    prevent_destroy = true
    ignore_changes = [tags]
  }
}

data "aws_dynamodb_table" "existing" {
  name  = "terraform-state-lock"
  count = 0 # always 0, just for reference
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
  lifecycle {
    prevent_destroy = true
    ignore_changes = [tags]
  }
}
