output "private_ips" {
  value = [ for i in aws_instance.instance : i.private_ip ]
}
output "public_ips" {
  value = [ for i in aws_instance.instance : i.public_ip ]
}
output "hostnames" {
  value = [ for i in aws_instance.instance : lookup(i.tags, "Name") ]
}
output "ids" {
  value = [ for i in aws_instance.instance : i.id ]
}
output "details" {
  value = [ for i, v in aws_instance.instance.*.public_ip : tomap({
    "public_ip" = "${v}",
    "private_ip" = aws_instance.instance["${i}"].private_ip,
    "name" = aws_instance.instance["${i}"].tags["Name"],
    "id" = aws_instance.instance["${i}"].id,
    "az" = aws_instance.instance["${i}"].availability_zone,
    "private_dns" = aws_instance.instance["${i}"].private_dns
  }) ]
}