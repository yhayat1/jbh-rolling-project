# Output the necessary details
output "ssh_private_key_path" {
  value       = local_file.private_key.filename
  description = "Local path of private SSH key"
}

output "aws_ssh_key_name" {
  value       = aws_key_pair.builder_key.key_name
  description = "Name of the AWS SSH key pair"
}

output "public_IP" {
  value       = aws_instance.ubuntu.public_ip
  description = "Public IP of provisioned EC2 instance"
}