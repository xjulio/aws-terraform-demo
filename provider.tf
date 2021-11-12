terraform {
  required_version = ">= 0.14"

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
