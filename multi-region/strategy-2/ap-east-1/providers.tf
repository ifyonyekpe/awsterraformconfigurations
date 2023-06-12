provider "aws" {
  region = local.region
  default_tags {
    tags = {
      ManagedBy = local.defaultTag
    }
  }
}