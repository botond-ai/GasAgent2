
# ECR repository for ECS app image
resource "aws_ecr_repository" "app" {
  name                 = "gasagent2-app"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = true
  }
}
