# Generate an SSH key pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save the private key locally
resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.root}/builder_key.pem"
  file_permission = "0600"
}

# Create an AWS key pair using the public key
resource "aws_key_pair" "builder_key" {
  key_name   = "yossih-builder-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_instance" "ubuntu" {
  ami                    = data.aws_ami.ubuntu.id
  subnet_id              = data.aws_subnet.subnet_id.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.security_group_id]

  # Associate the key pair with this instance
  key_name = aws_key_pair.builder_key.key_name

  tags = {
    Name = "builder"
  }
}

