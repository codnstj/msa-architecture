variable "region" {
  default = "ap-northeast-2"
}
variable "vpc_name" {
  type = string
  default = "k8s_test"
}
variable "azs" {
  type = list(string)
  default = ["ap-northeast-2a","ap-northeast-2c"]
}
variable "public_subnets" {
  type = list(string)
  default = ["10.0.0.0/24","10.0.1.0/24"]
}
variable "private_subnets" {
  type = list(string)
  default = ["10.0.100.0/24","10.0.101.0/24","10.0.102.0/24"]
}
variable "cluster_name" {
  type = string
  default = "k8s_test"
}
variable "ecr_name" {
  type = string
  default = "k8s_test"
}