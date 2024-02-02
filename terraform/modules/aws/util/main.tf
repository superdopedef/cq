resource "random_pet" "random_pet" {
  length    = var.random_pet_length
  separator = var.random_pet_separator
}

resource "random_uuid" "random_uuid" {}

data "aws_ami" "debian" {
  most_recent = true
  owners = ["136693071363"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name = "name"
    values = [var.debian_search]
  }
}
