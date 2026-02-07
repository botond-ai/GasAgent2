variable "aws_region" {
  description = "AWS region for backend."
  type        = string
  default     = "eu-central-1"
}

variable "openai_api_key" {
  description = "OpenAI API key for ECS backend container."
  type        = string
}
