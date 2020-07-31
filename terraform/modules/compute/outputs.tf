output "gm_private_ips" {
  description = "List of private ips of the instances"
  value       = aws_instance.instances.*.private_ip
}