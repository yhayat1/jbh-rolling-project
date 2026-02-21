# Python Flask Application (Local Development)

This directory contains the Flask application for local development and testing. The application displays AWS resources (EC2 instances, VPCs, Load Balancers, AMIs) in a web dashboard.

## 📁 Contents

- `app.py` - Main Flask application

## 🚀 Quick Start

### Prerequisites

- Python 3.8+
- AWS credentials configured
- Virtual environment (recommended)

### Setup

1. **Create and activate virtual environment**:

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

2. **Install dependencies**:
   ```bash
   pip install -r ../requirements.txt
   ```

3. **Configure AWS credentials**:

   The application uses **us-east-2** region by default (hardcoded in `app.py`).

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

4. **Run the application**:
   ```bash
   python app.py
   ```

5. **Access the application**: http://127.0.0.1:5001

## ⚙️ Configuration

### AWS Region

The application uses `us-east-2` region by default. To change the region, modify `REGION = "us-east-2"` in `app.py`.

### Required AWS Permissions

- `ec2:DescribeInstances`
- `ec2:DescribeVpcs`
- `ec2:DescribeImages`
- `elasticloadbalancing:DescribeLoadBalancers`

## 📝 How It Works

1. Flask starts a local web server on **port 5001**
2. On each request to `/`, boto3 fetches:
   - EC2 instances (`describe_instances`)
   - VPCs (`describe_vpcs`)
   - Load balancers (`describe_load_balancers`)
   - AMIs (`describe_images`)
3. Data is rendered into an HTML table with Jinja2 templates
4. The result is shown in your browser

## 🔧 Troubleshooting

**Problem**: `ModuleNotFoundError`
- **Solution**: Ensure virtual environment is activated and dependencies are installed

**Problem**: `NoCredentialsError`
- **Solution**: Verify AWS credentials are exported: `echo $AWS_ACCESS_KEY_ID`

**Problem**: Port 5001 already in use
- **Solution**: Find and kill the process using the port or change the port in `app.py`

**Problem**: Application shows empty tables
- **Solution**: Verify you have AWS resources in the specified region and check IAM permissions

## 🔐 Security Notes

- The application runs with `debug=True` by default - **disable this in production**
- Never commit AWS credentials to version control
- Use IAM users/roles with least privileges required

## 📚 Related Documentation

- Root project README: [../README.md](../README.md)
- Dockerized version: [../docker/README.md](../docker/README.md)
- Terraform infrastructure: [../terraform/aws/README.md](../terraform/aws/README.md)
