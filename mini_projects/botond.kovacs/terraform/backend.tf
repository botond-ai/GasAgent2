terraform {
  backend "s3" {
    bucket         = "terraform-state-640706953781-ai-agent-infra"
    key            = "cost-optimization/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
