data "aws_availability_zones" "available" {}

data "aws_ecr_repository" "service" {
  name = "dockerdeploy"
}