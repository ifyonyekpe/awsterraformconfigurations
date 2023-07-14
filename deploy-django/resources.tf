terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.2.0"
    }
  }
}

provider "aws" {
  region = local.region
}

locals {
  region     = var.region
  createdBy  = var.createdBy
  defaultTag = "Terraform"

  instanceAmiId = "ami-06b09bfacae1453cb"
  instanceType = "t2.micro"

  dbEngine        = var.dbEngine
  dbEngineVersion = var.dbEngineVersion
  dbUsername      = var.dbUsername
  dbPassword      = var.dbPassword
  dbName          = var.dbName

  commonTags = {
    ManagedBy = local.defaultTag
    CreatedBy = local.createdBy
  }
}

# Launch Ec2 Instances
module "api_instance" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~>5.0"
  count                       = 3
  ami                         = local.instanceAmiId
  instance_type               = local.instanceType
  user_data                   = data.template_file.userdata.rendered
  user_data_replace_on_change = true
  depends_on                  = [module.db]

  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.api_sg.id]

  associate_public_ip_address = true

  tags = merge(local.commonTags, {
    Name = format("django-api-server-%s", count.index)
  })
}

module "api_alb" {
  source             = "terraform-aws-modules/alb/aws"
  version            = "~> 8.0"
  name               = "django-api-alb"
  load_balancer_type = "application"

  vpc_id                = module.vpc.vpc_id
  subnets               = module.vpc.public_subnets
  security_groups       = [aws_security_group.alb_sg.id]
  create_security_group = false
  depends_on            = [module.api_instance]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    },
  ]

  target_groups = [
    {
      name_prefix      = "djan-"
      backend_protocol = "HTTP"
      backend_port     = 8000
      target_type      = "instance"
      targets = {
        for i, k in module.api_instance :
        "test-${i}" => {
          target_id = k.id
          port      = 8000
        }
      }
    }
  ]

  tags = local.commonTags
}

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.0"

  identifier = format("%s-instance", local.dbName)

  engine            = local.dbEngine
  engine_version    = local.dbEngineVersion
  instance_class    = "db.${local.instanceType}"
  allocated_storage = 10
  storage_type      = "gp2"
  network_type      = "IPV4"

  db_name                     = local.dbName
  username                    = local.dbUsername
  password                    = local.dbPassword
  manage_master_user_password = false

  port                   = "3306"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = local.commonTags

  db_subnet_group_name = local.dbSubnetGroupName

  family                      = format("%s%s", local.dbEngine, local.dbEngineVersion)
  major_engine_version        = local.dbEngineVersion
  deletion_protection         = false
  skip_final_snapshot         = true
  publicly_accessible         = true
  multi_az                    = false
  storage_encrypted           = false
  allow_major_version_upgrade = true
}


