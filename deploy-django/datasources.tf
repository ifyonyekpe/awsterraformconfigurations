data "aws_availability_zones" "available" {}

data "http" "my_public_ip" {
  url = "https://ifconfig.co/json"
  request_headers = {
    Accept = "application/json"
  }
}

data "template_file" "userdata" {
  template = file("templates/userdata.sh")
  vars = {
    database_url = "mysql://${local.dbUsername}:'${local.dbPassword}'@${module.db.db_instance_endpoint}/${local.dbName}"
  }
}
