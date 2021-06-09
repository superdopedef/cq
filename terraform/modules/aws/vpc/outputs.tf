output "id" {
  value = aws_vpc.vpc.id
}
output "master_subnet_ids" {
  value = aws_subnet.master.*.id
}
output "worker_subnet_ids" {
  value = aws_subnet.worker.*.id
}
output "master_sgs" {
  value = [aws_security_group.internal.id, aws_security_group.master-allow-ingress.id]
}
output "worker_sgs" {
  value = [aws_security_group.internal.id, aws_security_group.worker-allow-ingress.id]
}