# AWS Infrastructure with Terraform

This Terraform configuration provisions AWS infrastructure including EC2 instances and security groups using a modular approach.

## 📁 Project Structure

```
terraform/
├── aws/
│   ├── main.tf                 # Main configuration file
│   ├── providers.tf           # AWS provider configuration
│   ├── outputs.tf            # Output definitions
│   └── modules/
│       ├── ec2/              # EC2 instance module
│       │   ├── main.tf       # EC2 resources
│       │   ├── data.tf       # Data sources
│       │   ├── vars.tf       # Input variables
│       │   └── outputs.tf    # Module outputs
│       └── security_group/   # Security group module
│           ├── main.tf       # Security group resources
│           ├── data.tf       # Data sources
│           ├── vars.tf       # Input variables
│           └── outputs.tf    # Module outputs
```

## 🏗️ Architecture Overview

This Terraform configuration creates:

1. **Security Group Module**: Creates a security group with SSH (port 22) and custom port (5001) access
2. **EC2 Module**: Provisions an Ubuntu EC2 instance with:
   - Auto-generated SSH key pair
   - Security group attachment
   - Public IP assignment

## 📋 Prerequisites

- Terraform >= 1.0
- AWS CLI installed
- AWS account with EC2 permissions

## 🔑 AWS Credentials Setup

### Option 1: AWS CLI Configuration

Configure AWS credentials using the AWS CLI:

```bash
aws configure
```

Enter your credentials when prompted:
- AWS Access Key ID
- AWS Secret Access Key
- Default region (e.g., `us-east-1`)
- Default output format (e.g., `json`)

### Option 2: Environment Variables

Set AWS credentials as environment variables:

**Linux/macOS:**
```bash
export AWS_ACCESS_KEY_ID=your_access_key_id
export AWS_SECRET_ACCESS_KEY=your_secret_access_key
export AWS_DEFAULT_REGION=us-east-1
```

**Windows (PowerShell):**
```powershell
$env:AWS_ACCESS_KEY_ID="your_access_key_id"
$env:AWS_SECRET_ACCESS_KEY="your_secret_access_key"
$env:AWS_DEFAULT_REGION="us-east-1"
```

### Verify AWS Configuration

Test your AWS credentials:

```bash
aws sts get-caller-identity
```

This should return your AWS account information if credentials are properly configured.

## ⚙️ Configuration

### Default Variables

The configuration uses the following default values:

**EC2 Module (`modules/ec2/vars.tf`)**:
- Instance Type: `t3.medium`
- Subnet ID: `subnet-0852a4e422a2ea812`
- AMI: Latest Ubuntu 22.04 LTS (Jammy)

**Security Group Module (`modules/security_group/vars.tf`)**:
- VPC ID: `vpc-0b110d239f1211b4d`
- Allowed CIDR: `5.29.19.184/32` (Student's public IP)


## 🚀 Deployment Instructions

### 1. Initialize Terraform

```bash
cd terraform/aws
terraform init
```

### 2. Review the Plan

```bash
terraform plan
```

### 3. Apply the Configuration

```bash
terraform apply
```

When prompted, type `yes` to confirm the deployment.

### 4. Access Your Instance

After deployment, Terraform will output:
- `ssh_private_key_path`: Path to the generated private key
- `aws_ssh_key_name`: Name of the AWS key pair
- `public_IP`: Public IP address of the EC2 instance
- `security_group_id`: ID of the created security group

To SSH into your instance:

```bash
ssh -i modules/ec2/builder_key.pem ubuntu@<public_IP>
```

## 📤 Outputs

The configuration provides the following outputs:

| Output | Description |
|--------|-------------|
| `ssh_private_key_path` | Local path to the generated private SSH key |
| `aws_ssh_key_name` | Name of the AWS SSH key pair |
| `public_IP` | Public IP address of the EC2 instance |
| `security_group_id` | ID of the created security group |

## 🔧 Module Details

### EC2 Module

**Resources Created**:
- `tls_private_key.ssh_key`: Generates RSA 4096-bit SSH key pair
- `local_file.private_key`: Saves private key locally with 600 permissions
- `aws_key_pair.builder_key`: Creates AWS key pair from public key
- `aws_instance.ubuntu`: Provisions Ubuntu EC2 instance

**Data Sources**:
- `aws_ami.ubuntu`: Fetches latest Ubuntu 22.04 LTS AMI
- `aws_subnet.subnet_id`: References the specified subnet

### Security Group Module

**Resources Created**:
- `aws_security_group.allow_ssh_tcp_5001`: Main security group
- `aws_vpc_security_group_ingress_rule.allow_ssh_ipv4`: SSH access (port 22)
- `aws_vpc_security_group_ingress_rule.allow_tcp_5001_ipv4`: Custom port access (port 5001)
- `aws_vpc_security_group_egress_rule.allow_all_traffic_ipv4`: All outbound traffic

**Data Sources**:
- `aws_vpc.vpc_id`: References the specified VPC

## 🧹 Cleanup

To destroy all resources:

```bash
terraform destroy
```

When prompted, type `yes` to confirm the destruction.

## 🔐 Security Considerations

- SSH key is generated locally and stored with restricted permissions (600)
- Security group restricts access to specific IP address
- Default configuration uses student's specific IP for access
- Private key is stored locally and should be kept secure

## 📝 Notes

- The configuration is designed for educational purposes
- Default subnet and VPC IDs are specific to the student's AWS environment
- Instance is tagged with "builder" for identification
- Security group allows both SSH (22) and custom port (5001) access
- All outbound traffic is permitted from the security group

