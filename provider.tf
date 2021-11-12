terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.65.0"
    }
  }
  required_version = ">= 1.0.11"

  backend "remote" {
    organization = "DevOpsHouse"

    workspaces {
      name = "workspace-aws-demo-production"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
