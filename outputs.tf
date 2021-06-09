output "instance-details" {
  value = concat(module.master.details, module.worker.details)
}
