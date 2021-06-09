provider "aws" {
  profile = coalesce(var.aws_profile, "default")
  region  = var.aws_region
}

