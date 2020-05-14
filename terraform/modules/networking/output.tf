output "gm_public_subnet_1" {
  description = "GM Pubclic Subnet 1 ID"
  value       = aws_subnet.public_subnet_1.id
}

output "gm_vpc_id" {
  description = "GM VPC ID"
  value = aws_vpc.vpc.id
}

output "gm_sg_id" {
  description = "GM SG ID"
  value = aws_security_group.sg.id
}
