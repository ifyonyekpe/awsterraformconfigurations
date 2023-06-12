locals {
  region        = "us-east-1"
  defaultTag    = "Terraform"
  name          = "docker-ecsdemo" #"ex-${basename(path.cwd)}"
  module_prefix = "terraform-aws-modules/ecs/aws//modules"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  container_name = "ecsdemo-frontend"
  container_port = 3000
}