provider "aws" {
  region = var.region
}
locals {
  vpc_name = "msa_kube"
  cidr = "10.0.0.0./16"
  public_subnets = ["10.0.0.0/24","10.0.1.0/24"]
  private_subnets = ["10.0.100.0/24","10.0.101.0/24"]
  azs = ["ap-northeast-2a","ap-northeast-2c"]
  cluster_name = "msa_kube"
}

resource "aws_vpc" "this" {
  cidr_block = local.cidr
  tags = {Name = local.vpc_name}
}

resource "aws_default_route_table" "this" {
  
}