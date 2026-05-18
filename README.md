# DevOps Course Project - AWS Infrastructure & Application Deployment

> **Author:** Yossi Hayat &nbsp;·&nbsp; [GitHub @yhayat1](https://github.com/yhayat1) &nbsp;·&nbsp; [LinkedIn](https://www.linkedin.com/in/yossi-hayat-7b872b103/)
> Final project for the DevOps course.

This repository centralizes multiple DevOps topics and provides a complete solution for AWS infrastructure provisioning, application deployment, and containerization. The project demonstrates Infrastructure as Code (IaC), containerization, and DevOps best practices.

## 📁 Project Structure

```
jbh-rolling-project/
├── terraform/              # Infrastructure as Code
│   └── aws/               # AWS infrastructure provisioning
│       ├── main.tf        # Main Terraform configuration
│       ├── providers.tf   # Provider configurations
│       ├── outputs.tf     # Output definitions
│       ├── modules/       # Terraform modules
│       │   ├── ec2/      # EC2 instance module
│       │   │   ├── main.tf
│       │   │   ├── data.tf
│       │   │   ├── vars.tf
│       │   │   └── outputs.tf
│       │   └── security_group/  # Security group module
│       │       ├── main.tf
│       │       ├── data.tf
│       │       ├── vars.tf
│       │       └── outputs.tf
│       └── README.md      # Terraform documentation
├── python/                # Flask application (local development)
│   ├── app.py             # Main Flask application
│   └── README.md          # Python app documentation
├── docker/                # Dockerized application
│   ├── Dockerfile         # Multi-stage Docker build
│   ├── app.py             # Containerized Flask application
│   ├── requirements.txt   # Python dependencies
│   └── README.md          # Docker documentation
├── jenkins/               # Jenkins CI/CD environment
│   ├── docker-compose.yml # Jenkins master and slave setup
│   ├── Jenkinsfile        # Pipeline configuration
│   ├── master/            # Jenkins master Dockerfile and scripts
│   ├── slave/             # Jenkins slave Dockerfile and scripts
│   ├── casc_configs/      # Configuration as Code files
│   └── README.md          # Jenkins documentation
├── aws/                   # AWS resources and documentation
│   └── README.md          # AWS resources documentation
├── requirements.txt       # Python dependencies (for local development)
└── README.md             # This file (project overview)
```

## 🎯 Project Components

This repository contains multiple DevOps components, each with its own documentation:

### 1. [Terraform Infrastructure](./terraform/aws/README.md)
- Provisions EC2 instances and security groups on AWS
- Modular architecture with reusable modules
- Generates SSH key pairs for secure access
- Outputs infrastructure details for application deployment

### 2. [Python Application](./python/README.md)
- Local development Flask application
- Displays AWS resources (EC2, VPCs, Load Balancers, AMIs) via web dashboard
- Uses boto3 to interact with AWS services
- Runs on port 5001

### 3. [Docker Containerization](./docker/README.md)
- Multi-stage build for optimized image size
- Production-ready containerized Flask application
- Exposes application on port 5001
- Supports environment variable configuration

### 4. [Jenkins CI/CD](./jenkins/README.md)
- Jenkins master and slave environment
- Docker-enabled CI/CD pipeline
- Automated linting, security scanning, and Docker builds
- Pipeline configuration via Jenkinsfile

### 5. [AWS Resources](./aws/README.md)
- Screenshots and documentation
- AWS infrastructure reference materials

## 🚀 Quick Start

### Option 1: Run Locally (Python)

See [Python Application README](./python/README.md) for detailed instructions.

```bash
# Quick start
cd python
python3 -m venv .venv
source .venv/bin/activate
pip install -r ../requirements.txt
export AWS_ACCESS_KEY_ID=YOUR_KEY_ID
export AWS_SECRET_ACCESS_KEY=YOUR_SECRET
python app.py
```

### Option 2: Run with Docker

See [Docker README](./docker/README.md) for detailed instructions.

```bash
# Quick start
cd docker
docker build -t aws-dashboard:latest .
export AWS_ACCESS_KEY_ID=YOUR_KEY_ID
export AWS_SECRET_ACCESS_KEY=YOUR_SECRET
docker run -d -p 5001:5001 \
  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  --name aws-dashboard \
  aws-dashboard:latest
```

### Option 3: Deploy Infrastructure with Terraform

See [Terraform README](./terraform/aws/README.md) for detailed instructions.

```bash
# Quick start
cd terraform/aws
terraform init
terraform plan
terraform apply
```

### Option 4: Run CI/CD Pipeline with Jenkins

See [Jenkins README](./jenkins/README.md) for detailed instructions.

```bash
# Quick start
cd jenkins
docker-compose up -d --build
# Access Jenkins at http://localhost:8080 (admin/admin1234)
# Configure credentials and create pipeline job
```

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                    AWS Cloud                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │   EC2        │  │     VPC      │  │ Load        │  │
│  │  Instances   │  │              │  │ Balancers   │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────┘
                        ▲
                        │ boto3 API calls
                        │
        ┌───────────────┴───────────────┐
        │                               │
┌───────▼────────┐            ┌────────▼────────┐
│  Python App    │            │  Docker         │
│  (Local)       │            │  Container      │
│  Port: 5001    │            │  Port: 5001     │
│  Region: us-e2 │            │  Region: us-e1  │
└────────────────┘            └─────────────────┘
        │                               │
        └───────────────┬───────────────┘
                        │
                ┌───────▼────────┐
                │  Terraform     │
                │  Infrastructure│
                │  Provisioning  │
                └───────────────┘
```

## ✅ Prerequisites

### Required Tools
- **Python 3.8+** with `pip` and `venv`
- **Docker** and **Docker Compose** (for containerized deployment and Jenkins)
- **Terraform >= 1.0** (for infrastructure provisioning)
- **AWS CLI** (optional, but recommended)
- **Git** (for cloning the repository)

### AWS Account Requirements
- AWS account with appropriate permissions:
  - For Terraform: `ec2:*`, `vpc:*`, `iam:*` (or more restrictive)
  - For Flask app: 
    - `ec2:DescribeInstances`
    - `ec2:DescribeVpcs`
    - `ec2:DescribeImages`
    - `elasticloadbalancing:DescribeLoadBalancers`
- AWS credentials configured

## 📚 Component Documentation

Each component has detailed documentation:

| Component | Description | Documentation |
|-----------|-------------|--------------|
| **Terraform** | Infrastructure as Code | [terraform/aws/README.md](./terraform/aws/README.md) |
| **Python App** | Local Flask development | [python/README.md](./python/README.md) |
| **Docker** | Containerized deployment | [docker/README.md](./docker/README.md) |
| **Jenkins** | CI/CD pipeline environment | [jenkins/README.md](./jenkins/README.md) |
| **AWS Resources** | Screenshots and docs | [aws/README.md](./aws/README.md) |

## 🔧 Common Tasks

### Clone the Repository

```bash
git clone https://github.com/yhayat1/jbh-rolling-project.git
cd jbh-rolling-project
```

### Configure AWS Credentials

**Option A: AWS CLI Configuration (Recommended)**

```bash
aws configure
```

**Option B: Environment Variables**

On Linux/macOS:
```bash
export AWS_ACCESS_KEY_ID=YOUR_KEY_ID
export AWS_SECRET_ACCESS_KEY=YOUR_SECRET
export AWS_DEFAULT_REGION=your-region
```

On Windows (PowerShell):
```powershell
$env:AWS_ACCESS_KEY_ID="YOUR_KEY_ID"
$env:AWS_SECRET_ACCESS_KEY="YOUR_SECRET"
$env:AWS_DEFAULT_REGION="your-region"
```

## 🔐 Security Notes

- **Never commit** your `AWS_ACCESS_KEY_ID` or `AWS_SECRET_ACCESS_KEY` to GitHub
- Use **IAM users/roles** with the least privileges required
- Consider using **AWS CLI profiles** instead of plain env vars for long-term setups
- The Flask apps run with `debug=True` by default - **disable this in production**
- Security groups restrict access to your IP - keep this restriction in production
- SSH private keys are generated by Terraform - keep them secure and never commit them
- Consider using **IAM instance roles** instead of access keys when running on EC2

## 🚀 Next Steps

- Review component-specific documentation for detailed setup instructions
- Start with Terraform to provision infrastructure
- Run the application locally or in Docker
- Set up Jenkins CI/CD pipeline for automated builds and deployments
- Explore AWS resources through the web dashboard

## 👤 Author

**Yossi Hayat**
DevOps course final project — designed, built, and documented end-to-end.

- GitHub: [@yhayat1](https://github.com/yhayat1)
- LinkedIn: [linkedin.com/in/yossi-hayat](https://www.linkedin.com/in/yossi-hayat-7b872b103/)

If this project helped you, feel free to ⭐ the repo.

## 📜 License

MIT License. Free to use and modify.
