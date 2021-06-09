output "dns_name" {
    value = aws_lb.nlb.dns_name
}

output "private_ips" {
    value = aws_eip.nlb_eip.*.private_ip
}

output "public_ips" {
    value = aws_eip.nlb_eip.*.public_ip
}

output "tg_arn" {
    value = aws_lb_target_group.tg.*.arn
}