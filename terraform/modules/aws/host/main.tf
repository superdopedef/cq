data "template_file" "host_userdata" {
  template = file("${path.module}/userdata/host.userdata")
  vars = {
    public_key = var.public_key
  }
}

resource "aws_instance" "instance" {
  count = var.instance_count
  ami = var.ami_id
  instance_type = var.instance_flavour
  key_name = var.key_name
  iam_instance_profile = var.iam_instance_profile
  subnet_id = element(var.subnet_ids, count.index)
  vpc_security_group_ids = var.security_group_ids
  user_data = data.template_file.host_userdata.rendered
  associate_public_ip_address = true
  root_block_device {
    volume_type = "gp2"
    volume_size = var.disk_size
    delete_on_termination = var.delete_on_termination
  }
  tags = merge({ Name = format("${var.name_prefix}-${var.instance_name}-%02d", count.index + 1),
    k8s_instance = var.instance_name,
    cq_role = var.groups },
    var.aws_tags)
}


#locals {
#  providerID = [ for i, v in aws_instance.instance.*.id : tomap({
#    "id" = "${v}",
#    "az" = aws_instance.instance["${i}"].availability_zone,
#    "name" = aws_instance.instance["${i}"].private_dns }) ]
#}
