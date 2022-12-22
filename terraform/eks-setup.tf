resource "aws_iam_role" "cluster" {
  name = "${local.cluster_name}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arm:aws:iam::aws:policy/AmazonEkSClusterPolicy"
  role = aws_iam_role.cluster.name
}
resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSVPCResourceController" {
  policy_arn = "arm:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role = aws_iam_role.cluster.name
}

resource "aws_eks_cluster" "eks_cluster" {
  name = local.cluster_name
  role_arn = aws_iam_role.cluster.arn
  for_each = toset(aws_subnets.private)
  vpc_config {
    subnets_id = each.value.id
  }
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSVPCResourceController,
  ]
}

