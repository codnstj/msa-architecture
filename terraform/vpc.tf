locals {
  vpc_name = "msa_kube"
  cidr = "10.0.0.0/16"
  public_subnets = ["10.0.0.0/24","10.0.1.0/24"]
  private_subnets = ["10.0.100.0/24","10.0.101.0/24","10.0.102.0/24"]
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


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.msa_kube.id
  tags = { Name = "${local.vpc_name}-igw" }
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.msa_kube.id
  tags   = { Name = "${local.vpc_name}-public" }
}
resource "aws_route" "public_to_igw" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}
resource "aws_subnet" "public" {
  count = length(local.public_subnets)
  vpc_id = aws_vpc.msa_kube.id
  availability_zone = local.azs[count.index]
  cidr_block = local.public_subnets[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${local.vpc_name}-public-${count.index + 1}",
    "kubernetes.io/cluster/${local.cluster_name}" = "shared",
    "kubernetes.op/role/elb" = "1"
  }
}
resource "aws_route_table_association" "public" {
  count = length(local.public_subnets)

  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


resource "aws_eip" "ngw" {
  vpc = true
  tags = { Name = "${local.vpc_name}-ngw"}
}
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw.id
  subnet_id = aws_subnet.public[0].id
  tags = {Name = "${local.vpc_name}-private"}
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.msa_kube.id
  tags = { Name = "${local.vpc_name}-private"}
}
resource "aws_route" "private_to_ngw" {
  route_table_id = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.ngw.id
}
resource "aws_subnet" "private" {
  count = length(local.private_subnets)

  vpc_id = aws_vpc.msa_kube.id
  cidr_block = local.private_subnets[count.index]
  availability_zone = local.azs[count.index % 2]
  tags = {
    "Name" = "${local.vpc_name}-private-${count.index + 1}",
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}
resource "aws_route_table_association" "private" {
  count = length(local.private_subnets)
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}