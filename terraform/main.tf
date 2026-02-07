resource "aws_lb_target_group" "main" {
  name     = "ai-agent-tutorial-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"
}
data "aws_lb" "main" {
  name = "ai-agent-tutorial-alb"
}


resource "aws_lb_listener" "main" {
  load_balancer_arn = data.aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
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
  container_definitions = jsonencode([
    {
      name      = "backend"
      image     = "640706953781.dkr.ecr.eu-central-1.amazonaws.com/ai-agent-app:latest"
      essential = true
      portMappings = [
        { containerPort = 80, hostPort = 80 }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/ai-agent-task"
          awslogs-region        = "eu-central-1"
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [
        {
          name  = "OPENAI_API_KEY"
          value = var.openai_api_key
        }
      ]
    }
  ])
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
  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "backend"
    container_port   = 80
  }
  depends_on = [aws_ecs_cluster.main, data.aws_lb_listener.main]
}
