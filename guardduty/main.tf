module "guardduty_us-east-1" {
  source = "./test-module"
  providers = {
    aws = aws.us-east-1
  }
}

module "guardduty_us-east-2" {
  source = "./test-module"
  providers = {
    aws = aws.us-east-2
  }
}