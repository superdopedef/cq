variable "aws_region" {}

variable "aws_profile" {}

variable "aws_vpc_cidr" {}

variable "aws_tags" {}

variable "aws_domain_name" {}

variable "instance_flavour" {
  default = "t2.medium"
}

variable "master_count" {
  default = 3
}

variable "worker_count" {
  default = 3
}