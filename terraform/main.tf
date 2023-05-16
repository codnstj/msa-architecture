provider "aws" {
  region = var.region
  shared_config_files = ["~/.aws/credentials"]
  profile = "saltware"
  default_tags {
    tags = {
      "Terraform" = "True"
      "Project" = "${var.cluster_name}-project"
    }
  }
}

terraform {
#   backend "remote" {
#     organization = "codns"
#     workspaces {
#       name = "msa_kube"
#     }
#   }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}