terraform {
  required_version = ">= 1.0"
  
  backend "s3" {
    bucket         = "devops-project-state-bucket"
    key            = "devops-project/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "terraform_lock"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b"]
  project_name       = var.project_name
}

module "eks" {
  source = "./modules/eks"
  
  cluster_name    = "${var.project_name}-cluster"
  cluster_version = "1.28"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids
}

module "ecr" {
  source = "./modules/ecr"
  
  repositories = ["backend", "frontend"]
  project_name = var.project_name
}