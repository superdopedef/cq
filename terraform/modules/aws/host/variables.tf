variable "instance_name" {
    type = string
}

variable "ami_id" {
    type = string
}

variable "key_name" {
    type = string
}

variable "subnet_ids" {
    type = list
}

variable "security_group_ids" {
    type = list
}

variable "instance_count" {
    type = string
}

variable "instance_flavour" {
    type = string
}

variable "public_key" {
    type = string
}

variable "disk_size" {
    type = number
    default = 50
}

variable "name_prefix" {
    type = string
}

variable "aws_tags" {
    type = map 
}

variable "groups" {
    type = string
}

variable "iam_instance_profile" {
    type=string
}

variable "associate_public_ip_address" {
    type = bool
    default = true
}

variable "delete_on_termination" {
    type = bool
    default = true
}
