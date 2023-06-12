module "guardduty_us-east-1" {
  source = "../../modules/guardduty"
  //source = "https://github.com/ifyonyekpe/awsterraformconfigurations.git/modules/guardduty"
  providers = {
    aws = aws.us-east-1
  }
}

module "guardduty_us-east-2" {
  source = "../../modules/guardduty"
  //source = "https://github.com/ifyonyekpe/awsterraformconfigurations.git/modules/guardduty"
  providers = {
    aws = aws.us-east-2
  }
}