# Output modules' outputs
output "ssh_private_key_path" {
  value     = module.ec2.ssh_private_key_path
}

output "aws_ssh_key_name" {
  value = module.ec2.aws_ssh_key_name
}

output "public_IP" {
  value = module.ec2.public_IP
}

output "security_group_id" {
  value = module.security_group.security_group_id
}