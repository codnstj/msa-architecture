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
  vpc_config {
    subnet_ids = aws_subnet.private[*].id
  }
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSVPCResourceController,
  ]
}


resource "aws_iam_role" "pod_execution" {
  name = "${local.cluster_name}-eks-pod-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Effect = "Allow",
        Principal = {
            Service = "eks-fargate-pods.amazonaws.com"
        },
        Action = "sts.AssumeRole"
    }]
  })
}
resource "aws_iam_role_policy_attachment" "pod_execution_AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role = aws_iam_role.pod_execution.name
}
resource "aws_eks_fargate_profile" "default" {
    cluster_name = aws_eks_cluster.eks_cluster.name
    fargate_profile_name = "fp-default"
    pod_execution_role_arn = aws_iam_role.pod_execution.arn
    subnet_ids = aws_subnet.private[*].id
    selector {
        namespace = "default"
    }
    selector {
        namespace = "kube-system"
    }
}