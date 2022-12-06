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

resource "aws_vpc" "msa_kube" {
  cidr_block = local.cidr
  tags = {Name = local.vpc_name}
}

resource "aws_default_route_table" "default_rt" {
  default_route_table_id = aws_vpc.msa_kube.default_route_table_id
  tags = { Name = "${local.vpc_name}-default" }
}
resource "aws_default_security_group" "default_sg" {
  vpc_id = aws_vpc.msa_kube.id
  tags = { Name = "${local.vpc_name}-default" }
}
resource "aws_security_group" "security_group" {
  vpc_id = aws_vpc.msa_kube.id
  tags = { Name = "${local.vpc_name}-igw" }
}
resource "aws_internet_gateway" "name" {
  vpc_id = aws_vpc.msa_kube.id
  tags = { Name = "${local.vpc_name}-igw" }
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.msa_kube.id
  tags   = { Name = "${local.vpc_name}-public" }
}