# AWS Resource Dashboard (Flask + Boto3 + Terraform)

This project provides a complete solution for provisioning AWS infrastructure and displaying AWS resources through a **Flask web application**. The project demonstrates Infrastructure as Code (IaC) with Terraform and AWS automation with boto3.

The project consists of:
- **Terraform configuration** to provision EC2 instances and security groups
- **Flask web application** that displays AWS resources (EC2 Instances, VPCs, Load Balancers, AMIs)
- **Automated infrastructure** setup for deploying the application

------------------------------------------------------------------------

## 📁 Project Structure

```
jbh-rolling-project/
├── terraform/              # Infrastructure as Code
│   └── aws/
│       ├── main.tf        # Main Terraform configuration
│       ├── providers.tf  # Provider definitions
│       ├── outputs.tf     # Terraform outputs
│       └── modules/
│           ├── ec2/       # EC2 instance module
│           └── security_group/  # Security group module
├── python/                # Flask application
│   └── app.py             # Main Flask application
├── jenkins/               # CI/CD pipeline
│   └── Jenkinsfile        # Jenkins pipeline configuration
├── requirements.txt       # Python dependencies
└── README.md             # This file
```

------------------------------------------------------------------------

## 📖 Background

This project demonstrates:
- **Infrastructure as Code (IaC)**: Using Terraform to provision AWS resources
- **Flask web development**: Serving a lightweight web dashboard
- **AWS automation**: Using boto3 to interact with AWS services programmatically
- **Security best practices**: Using environment variables for credentials
- **DevOps workflows**: Combining infrastructure provisioning with application deployment

This makes it a useful starting point for **cloud admins, DevOps engineers, or learners** exploring AWS automation and Infrastructure as Code.

------------------------------------------------------------------------

## ✅ Prerequisites

### Required Tools
- **Python 3.8+** with `pip` and `venv`
- **Terraform >= 1.0** (for infrastructure provisioning)
- **AWS CLI** (optional, but recommended for credential management)
- **Git** (for cloning the repository)

### AWS Account Requirements
- AWS account with appropriate permissions:
  - For Terraform: `ec2:*`, `vpc:*`, `iam:*` (or more restrictive permissions)
  - For Flask app: 
    - `ec2:DescribeInstances`
    - `ec2:DescribeVpcs`
    - `ec2:DescribeImages`
    - `elasticloadbalancing:DescribeLoadBalancers`
- AWS credentials configured (see setup instructions below)

------------------------------------------------------------------------

## 🏗️ Architecture Overview

This project follows a two-part architecture:

1. **Infrastructure Layer (Terraform)**:
   - Provisions EC2 instance named "builder"
   - Creates security groups with SSH (port 22) and HTTP (port 5001) access
   - Generates and manages SSH key pairs
   - Outputs instance details for application deployment

2. **Application Layer (Flask)**:
   - Runs on the provisioned EC2 instance (or locally for development)
   - Connects to AWS using boto3 to fetch resource information
   - Displays AWS resources in a web dashboard on port 5001

**Connection**: The Terraform-provisioned EC2 instance can host the Flask application, allowing you to deploy the dashboard on AWS infrastructure.

------------------------------------------------------------------------

## ⚙️ Setup Instructions

### Part 1: Infrastructure Provisioning (Terraform)

#### 1. Clone the Repository

```bash
git clone https://github.com/yhayat1/jbh-rolling-project.git
cd jbh-rolling-project
```

#### 2. Configure AWS Credentials for Terraform

**Option A: AWS CLI Configuration (Recommended)**

```bash
aws configure
```

Enter your credentials when prompted:
- AWS Access Key ID
- AWS Secret Access Key
- Default region: Set to the region where your VPC exists
- Default output format: `json`

**Option B: Environment Variables**

On Linux/macOS:
```bash
export AWS_ACCESS_KEY_ID=YOUR_KEY_ID
export AWS_SECRET_ACCESS_KEY=YOUR_SECRET
export AWS_DEFAULT_REGION=your-region  # Set to the region where your VPC exists
```

On Windows (PowerShell):
```powershell
$env:AWS_ACCESS_KEY_ID="YOUR_KEY_ID"
$env:AWS_SECRET_ACCESS_KEY="YOUR_SECRET"
$env:AWS_DEFAULT_REGION="your-region"  # Set to the region where your VPC exists
```

**Note**: The region must match where your VPC exists. VPCs are region-specific resources, so Terraform must run in the same region as the VPC. The Terraform provider will use the region from your AWS credentials configuration.

#### 3. Configure Hardcoded Values

⚠️ **Important**: This codebase contains hardcoded values that are specific to the original developer's AWS account. You **must** update these values before using the code:

**Required Changes:**

1. **VPC ID** - Edit `terraform/aws/modules/security_group/vars.tf`:
   ```hcl
   variable "vpc_id" {
     type        = string
     default     = "vpc-0b110d239f1211b4d"  # ⚠️ CHANGE THIS to your VPC ID
     description = "Default vpc ID"
   }
   ```
   - Find your VPC ID: AWS Console → VPC → Your VPCs
   - Or use CLI: `aws ec2 describe-vpcs --query 'Vpcs[*].[VpcId,Tags[?Key==\`Name\`].Value|[0]]' --output table`

2. **Subnet ID** - Edit `terraform/aws/modules/ec2/vars.tf`:
   ```hcl
   variable "subnet_id" {
     type        = string
     default     = "subnet-0852a4e422a2ea812"  # ⚠️ CHANGE THIS to your public subnet ID
     description = "Default public subnet ID"
   }
   ```
   - Find a public subnet in your VPC: AWS Console → VPC → Subnets
   - Or use CLI: `aws ec2 describe-subnets --filters "Name=vpc-id,Values=YOUR_VPC_ID" --query 'Subnets[*].[SubnetId,AvailabilityZone,MapPublicIpOnLaunch]' --output table`
   - Ensure the subnet is in the same VPC as above and has internet gateway route

3. **Your Public IP Address** - Edit `terraform/aws/modules/security_group/vars.tf`:
   ```hcl
   variable "allowed_cidr" {
     type        = string
     default     = "5.29.19.184/32"  # ⚠️ CHANGE THIS to your public IP (format: "x.x.x.x/32")
     description = "Student public IP"
   }
   ```
   - Find your public IP: `curl ifconfig.me` or visit https://whatismyipaddress.com
   - Use format: `"YOUR_IP/32"` (e.g., `"203.0.113.1/32"`)

**Optional Changes (Recommended):**

4. **Security Group Name** - Edit `terraform/aws/modules/security_group/main.tf`:
   ```hcl
   resource "aws_security_group" "allow_ssh_tcp_5001" {
     name        = "yossih-builder-sg"  # ⚠️ CHANGE THIS to avoid conflicts (e.g., "yourname-builder-sg")
     ...
   }
   ```
   - Change `"yossih-builder-sg"` to a unique name to avoid conflicts with other users

5. **Key Pair Name** - Edit `terraform/aws/modules/ec2/main.tf`:
   ```hcl
   resource "aws_key_pair" "builder_key" {
     key_name   = "yossih-builder-key"  # ⚠️ CHANGE THIS to avoid conflicts (e.g., "yourname-builder-key")
     ...
   }
   ```
   - Change `"yossih-builder-key"` to a unique name to avoid conflicts with other users

**Why These Changes Are Necessary:**
- The hardcoded VPC and subnet IDs belong to a specific AWS account and won't exist in yours
- The hardcoded IP address restricts access to the original developer's IP
- Resource names with personal identifiers can cause conflicts if multiple people use the same code
- Without these changes, `terraform apply` will fail with errors about non-existent resources

#### 4. Initialize and Apply Terraform

```bash
cd terraform/aws
terraform init
terraform plan    # Review the execution plan - verify VPC and subnet IDs are correct
terraform apply   # Type 'yes' to confirm
```

After successful deployment, Terraform will output:
- `public_IP`: Public IP address of the EC2 instance
- `ssh_private_key_path`: Path to the generated SSH private key
- `aws_ssh_key_name`: Name of the AWS key pair
- `security_group_id`: ID of the created security group

For detailed Terraform documentation, see [terraform/aws/README.md](terraform/aws/README.md).

### Part 2: Flask Application Setup

#### 1. Create & Activate Virtual Environment

On Linux/macOS:
```bash
python3 -m venv .venv
source .venv/bin/activate
```

On Windows (PowerShell):
```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
```

#### 2. Install Dependencies

```bash
pip install -r requirements.txt
```

#### 3. Configure AWS Credentials and Region

The Flask application requires AWS credentials and uses **us-east-2** region by default (hardcoded in `python/app.py`).

On Linux/macOS:
```bash
export AWS_ACCESS_KEY_ID=YOUR_KEY_ID
export AWS_SECRET_ACCESS_KEY=YOUR_SECRET
export AWS_DEFAULT_REGION=us-east-2
```

On Windows (PowerShell):
```powershell
$env:AWS_ACCESS_KEY_ID="YOUR_KEY_ID"
$env:AWS_SECRET_ACCESS_KEY="YOUR_SECRET"
$env:AWS_DEFAULT_REGION="us-east-2"
```

**Note**: The Flask app currently uses `us-east-2` region. If you need a different region, modify `REGION = "us-east-2"` in `python/app.py`.

#### 4. Run the Application

```bash
python python/app.py
```

Then open <http://127.0.0.1:5001> in your browser.

------------------------------------------------------------------------

## 🚀 Deployment

### Deploying Flask App to EC2 Instance

After provisioning the EC2 instance with Terraform:

1. **SSH into the instance**:
   ```bash
   ssh -i terraform/aws/modules/ec2/builder_key.pem ubuntu@<public_IP>
   ```

2. **Install dependencies on the instance**:
   ```bash
   sudo apt update
   sudo apt install -y python3 python3-pip git
   ```

3. **Clone and setup the application**:
   ```bash
   git clone https://github.com/yhayat1/jbh-rolling-project.git
   cd jbh-rolling-project
   python3 -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt
   ```

4. **Configure AWS credentials** (use IAM roles or environment variables):
   ```bash
   export AWS_ACCESS_KEY_ID=YOUR_KEY_ID
   export AWS_SECRET_ACCESS_KEY=YOUR_SECRET
   export AWS_DEFAULT_REGION=us-east-2
   ```

5. **Run the application**:
   ```bash
   python python/app.py
   ```

6. **Access the application**:
   - The security group allows access on port 5001 from your IP
   - Access via: `http://<public_IP>:5001`

**Note**: For production, consider using a process manager like `systemd` or `supervisord` to keep the application running.

------------------------------------------------------------------------

## 📝 How It Works

### Terraform Infrastructure
1. Terraform provisions an EC2 instance in the specified VPC
2. Creates a security group allowing SSH (22) and HTTP (5001) access
3. Generates SSH key pair for secure access
4. Outputs connection details for application deployment

### Flask Application
1. Flask starts a local web server on **port 5001**
2. On each request to `/`, boto3 fetches:
   - EC2 instances (`describe_instances`)
   - VPCs (`describe_vpcs`)
   - Load balancers (`describe_load_balancers`)
   - AMIs (`describe_images`)
3. Data is rendered into an HTML table with Jinja2 templates
4. The result is shown in your browser

------------------------------------------------------------------------

## 🔧 Troubleshooting

### Terraform Issues

**Problem**: `terraform apply` fails with VPC/subnet errors
- **Solution**: 
  - ⚠️ **First check**: Did you update the hardcoded values? See Step 3 in setup instructions
  - Verify you've configured the correct VPC ID in `terraform/aws/modules/security_group/vars.tf` (replace `vpc-0b110d239f1211b4d`)
  - Verify you've configured a valid subnet ID in `terraform/aws/modules/ec2/vars.tf` that exists in your VPC (replace `subnet-0852a4e422a2ea812`)
  - Ensure the subnet is a public subnet (has route to internet gateway)
  - Ensure your AWS region matches where the VPC exists
  - Verify the VPC and subnet IDs exist: `aws ec2 describe-vpcs --vpc-ids vpc-YOUR-ID` and `aws ec2 describe-subnets --subnet-ids subnet-YOUR-ID`

**Problem**: `terraform apply` fails with "key pair already exists" or "security group already exists"
- **Solution**: 
  - The code contains hardcoded resource names (`yossih-builder-key`, `yossih-builder-sg`) that may conflict
  - Update the resource names in `terraform/aws/modules/security_group/main.tf` and `terraform/aws/modules/ec2/main.tf` to use unique names
  - Or delete the existing resources from AWS if they belong to you

**Problem**: Cannot SSH into the instance
- **Solution**: 
  - Verify the security group allows your IP address
  - Check that the private key has correct permissions: `chmod 600 builder_key.pem`
  - Ensure the instance has a public IP address

### Flask Application Issues

**Problem**: `ModuleNotFoundError` when running the app
- **Solution**: Ensure virtual environment is activated and dependencies are installed: `pip install -r requirements.txt`

**Problem**: `NoCredentialsError` or authentication errors
- **Solution**: 
  - Verify AWS credentials are set: `echo $AWS_ACCESS_KEY_ID`
  - Check credentials are valid: `aws sts get-caller-identity`
  - Ensure the region matches where your resources exist

**Problem**: Application can't connect to AWS services
- **Solution**: 
  - Verify IAM permissions are correct
  - Check the AWS region matches your resources
  - Ensure network connectivity (if running on EC2, check security groups)

**Problem**: Port 5001 already in use
- **Solution**: 
  - Find the process using the port: `lsof -i :5001` (macOS/Linux) or `netstat -ano | findstr :5001` (Windows)
  - Kill the process or change the port in `app.py`

**Problem**: Application shows empty tables
- **Solution**: 
  - Verify you have AWS resources in the specified region
  - Check IAM permissions allow `Describe*` operations
  - Ensure you're querying the correct AWS account

### General Issues

**Problem**: Wrong repository name in clone command
- **Solution**: Use `jbh-rolling-project` (not `jbh-aws-module-project`)

**Problem**: Region mismatch between Terraform and Flask app
- **Solution**: 
  - Terraform uses the region from your AWS credentials configuration (must match where your VPC exists)
  - Flask app uses `us-east-2` (hardcoded in `app.py`)
  - Modify `REGION` in `python/app.py` if you need consistency with your Terraform region

------------------------------------------------------------------------

## 🔐 Security Notes

- **Never commit** your `AWS_ACCESS_KEY_ID` or `AWS_SECRET_ACCESS_KEY` to GitHub
- Use **IAM users/roles** with the least privileges required
- Consider using **AWS CLI profiles** instead of plain env vars for long-term setups
- The Flask app runs with `debug=True` by default - **disable this in production**
- Security groups restrict access to your IP - keep this restriction in production
- SSH private keys are generated by Terraform - keep them secure and never commit them
- Consider using **IAM instance roles** instead of access keys when running on EC2

------------------------------------------------------------------------

## 🚀 Next Steps (Optional Enhancements)

- Filter resources by **tags** (e.g., show only `Environment=Prod`)
- Add authentication to the web UI
- Deploy to a container (Docker) or serverless platform
- Extend support for more AWS services (S3, RDS, etc.)
- Add error handling and logging to the Flask application
- Implement health checks and monitoring
- Use IAM roles instead of access keys for EC2 instances
- Add CI/CD pipeline for automated deployments

------------------------------------------------------------------------

## 📜 License

MIT License. Free to use and modify.
