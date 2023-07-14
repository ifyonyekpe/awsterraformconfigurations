locals {
  cidrBlock    = var.cidrBlock
  subnetCount  = 2
  ifconfigJson = jsondecode(data.http.my_public_ip.response_body)

  dbSubnetGroupName = "comp-subnet-group"
}

resource "aws_security_group" "alb_sg" {
  lifecycle {
    create_before_destroy = false
  }

  name        = "alb-sg"
  description = "ALB Security group"
  vpc_id      = module.vpc.vpc_id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = false
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.commonTags
}

resource "aws_security_group" "api_sg" {
  lifecycle {
    create_before_destroy = false
  }
  name        = "api-sg"
  description = "API Security group"

  vpc_id = module.vpc.vpc_id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(local.ifconfigJson.ip)}/32"]
  }

  ingress {
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  tags = local.commonTags
}

resource "aws_security_group" "rds_sg" {
  lifecycle {
    create_before_destroy = false
  }
  name        = "rds_sg"
  description = "MySQL Security group"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.api_sg.id]
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.api_sg.id]
  }

  tags = local.commonTags
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~>5.0"

  name = "comp-vpc"

  cidr            = local.cidrBlock
  azs             = slice(data.aws_availability_zones.available.names, 0, local.subnetCount)
  private_subnets = var.privateSubnets
  public_subnets  = var.publicSubnets

  create_igw = true

  enable_nat_gateway = false

  create_database_subnet_group           = true
  database_subnet_group_name             = local.dbSubnetGroupName
  create_database_internet_gateway_route = true
  create_database_subnet_route_table     = true
  database_subnets                       = var.dbSubnets
  tags                                   = local.commonTags
}