provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "prod-support-lab"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}