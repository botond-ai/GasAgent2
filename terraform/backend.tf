terraform {
  backend "s3" {
    bucket         = "terraform-state-021580456215-ai-agent-infra"
    key            = "ai-agent-tutorial/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true  # State file titkosítása
    dynamodb_table = "terraform-state-lock"  # Párhuzamos futás megakadályozása
  }
}
