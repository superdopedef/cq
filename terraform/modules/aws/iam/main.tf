resource "aws_iam_role" "master" {
  name               = "${var.name_prefix}-k8s-master-role"
  assume_role_policy = file("${path.module}/files/role-trust.json")
}

resource "aws_iam_instance_profile" "master" {
  name  = "${var.name_prefix}-k8s-master-profile"
  role  = aws_iam_role.master.id
}

resource "aws_iam_role_policy" "master" {
  name   = "${var.name_prefix}-k8s-master-policy"
  role   = aws_iam_role.master.id
  policy = file("${path.module}/files/cp-policy.json")
}

resource "aws_iam_role" "worker" {
  name               = "${var.name_prefix}-k8s-worker-role"
  assume_role_policy = file("${path.module}/files/role-trust.json")
}

resource "aws_iam_instance_profile" "worker" {
  name  = "${var.name_prefix}-k8s-worker-profile"
  role  = aws_iam_role.worker.id
}

resource "aws_iam_role_policy" "worker" {
  name   = "${var.name_prefix}-k8s-worker-policy"
  role   = aws_iam_role.worker.id
  policy = file("${path.module}/files/wk-policy.json")
}
