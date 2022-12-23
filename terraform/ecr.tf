locals{
    app_name = "msa_kube"
}
resource "aws_ecr_repository" "msa_kube" {
  name = local.app_name
  
}