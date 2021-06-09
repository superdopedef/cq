output "master" {
  value = aws_iam_instance_profile.master.name
}

output "worker" {
  value = aws_iam_instance_profile.worker.name
}
