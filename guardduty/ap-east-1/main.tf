module "guardduty_ap-east-1" {
  source = "./test-module"
  providers = {
    aws = aws.ap-east-1
  }
}