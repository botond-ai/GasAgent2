module "bootstrap" {
  source = "../terraform-bootstrap"
  aws_region = var.aws_region
}

resource "aws_ecr_repository" "ai_agent_app" {
  name = "ai-agent-app"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}
