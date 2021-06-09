resource aws_eip "nlb_eip" {
  count = length(var.subnet_ids)
  vpc = true
  tags = merge({ Name = format("${var.name_prefix}-master-eip%02d", count.index + 1) },
          var.aws_tags)
}

resource "aws_lb" "nlb" {
  name = "${var.name_prefix}-master-nlb"
  load_balancer_type = "network"

  dynamic "subnet_mapping" {
    for_each = zipmap(var.subnet_ids, aws_eip.nlb_eip.*.id)
    content {
      subnet_id     = subnet_mapping.key
      allocation_id = subnet_mapping.value
    }
  }

  tags = merge({ Name = "${var.name_prefix}-master-nlb" },
          var.aws_tags)
}

resource "aws_lb_target_group" "tg" {
  name     = "${var.name_prefix}-master-tg"
  port     = 6443
  protocol = "TCP"
  vpc_id   = var.vpc_id
  health_check {
    port                = 6443
    protocol            = "TCP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
  }
  tags = merge({ Name = "${var.name_prefix}-master-tg" },
          var.aws_tags)
}

resource "aws_lb_listener" "listen" {
  load_balancer_arn = aws_lb.nlb.arn
  port = 6443
  protocol = "TCP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_target_group_attachment" "attachment" {
  count = length(var.instance_ids)
  target_group_arn = aws_lb_target_group.tg.arn
  target_id = var.instance_ids[count.index]
}
