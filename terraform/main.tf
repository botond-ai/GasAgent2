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

resource "aws_ecs_cluster" "main" {
  name = "ai-agent-tutorial-cluster"
}

resource "aws_ecs_task_definition" "main" {
  family                   = "ai-agent-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::640706953781:role/ecsTaskExecutionRole"
  container_definitions    = <<DEFS
[
  {
    "name": "backend",
    "image": "640706953781.dkr.ecr.eu-central-1.amazonaws.com/ai-agent-app:latest",
    "essential": true,
    "portMappings": [
      { "containerPort": 80, "hostPort": 80 }
    ]
  }
]
DEFS
}

resource "aws_ecs_service" "main" {
  name            = "ai-agent-tutorial-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = ["subnet-015c5678674f58a8e"]
    assign_public_ip = true
  }
  depends_on = [aws_ecs_cluster.main]
}
