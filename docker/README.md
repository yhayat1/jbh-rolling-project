# Dockerized AWS Resource Dashboard

This directory contains the Dockerized version of the AWS Resource Dashboard Flask application. The application is containerized using a multi-stage build for optimized image size and production deployment.

## 📁 Contents

- `Dockerfile` - Multi-stage Docker build configuration
- `app.py` - Flask application for AWS resource dashboard
- `requirements.txt` - Python dependencies
- `.dockerignore` - Files to exclude from Docker build context

## 🚀 Quick Start

### Build the Docker Image

```bash
cd docker
docker build -t aws-dashboard:latest .
```

### Run the Container

**Step 1: Export AWS credentials** (required before running the container):

On Linux/macOS:
```bash
export AWS_ACCESS_KEY_ID=YOUR_KEY_ID
export AWS_SECRET_ACCESS_KEY=YOUR_SECRET
```

On Windows (PowerShell):
```powershell
$env:AWS_ACCESS_KEY_ID="YOUR_KEY_ID"
$env:AWS_SECRET_ACCESS_KEY="YOUR_SECRET"
```

**Step 2: Run the container** (credentials will be passed from your environment):
```bash
docker run -d \
  -p 5001:5001 \
  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  --name aws-dashboard \
  aws-dashboard:latest
```

**Alternative: Using environment file**:
```bash
docker run -d \
  -p 5001:5001 \
  --env-file .env \
  --name aws-dashboard \
  aws-dashboard:latest
```

**Access the application**: http://localhost:5001

## 📋 Prerequisites

- **Docker** installed and running
- **AWS credentials** (Access Key ID and Secret Access Key)
- AWS account with appropriate IAM permissions:
  - `ec2:DescribeInstances`
  - `ec2:DescribeVpcs`
  - `ec2:DescribeImages`
  - `elasticloadbalancing:DescribeLoadBalancers`

## 🔧 Configuration

### Environment Variables

**Required**:
- `AWS_ACCESS_KEY_ID` - Your AWS access key ID
- `AWS_SECRET_ACCESS_KEY` - Your AWS secret access key

**Optional**:
- `AWS_DEFAULT_REGION` - AWS region (default: `us-east-1`)

### AWS Region

The application uses **us-east-1** region by default (configured in `app.py`). This is separate from the local Python application (`python/app.py`) which uses `us-east-2`.

To change the region, modify `REGION = "us-east-1"` in `app.py` or set `AWS_DEFAULT_REGION` environment variable.

## 🏗️ Docker Image Details

- **Base Image**: `python:3.11-slim`
- **Multi-stage Build**: Yes
  - **Stage 1 (builder)**: Installs Python dependencies
  - **Stage 2 (runtime)**: Copies only necessary files and dependencies
- **Exposed Port**: 5001
- **Working Directory**: `/app`
- **Command**: `python app.py`

## 📝 Multi-Stage Build Benefits

The Dockerfile uses a multi-stage build to:
- Reduce final image size by excluding build tools
- Separate build dependencies from runtime dependencies
- Improve security by minimizing the attack surface
- Speed up builds by caching dependency installation

## 🔍 Troubleshooting

### Container fails to start

```bash
# Check container logs
docker logs aws-dashboard

# Check if container is running
docker ps -a | grep aws-dashboard
```

### Application can't connect to AWS

1. **Verify environment variables**:
   ```bash
   docker exec aws-dashboard env | grep AWS
   ```

2. **Check AWS credentials**:
   ```bash
   docker exec aws-dashboard python -c "import os; print('AWS_ACCESS_KEY_ID' in os.environ)"
   ```

3. **Verify IAM permissions**: Ensure your AWS credentials have the required permissions

4. **Check region**: Verify the region matches where your AWS resources exist

### Port 5001 already in use

```bash
# Find process using port 5001
lsof -i :5001  # macOS/Linux
netstat -ano | findstr :5001  # Windows

# Use a different port
docker run -d -p 5002:5001 --name aws-dashboard aws-dashboard:latest
```

### Build fails

1. **Ensure you're in the docker directory**:
   ```bash
   cd docker
   docker build -t aws-dashboard:latest .
   ```

2. **Check requirements.txt exists**:
   ```bash
   ls -la requirements.txt
   ```

3. **Check Docker daemon is running**:
   ```bash
   docker info
   ```

## 🔐 Security Notes

- **Never commit** AWS credentials to version control
- Use `.env` files for local development (add `.env` to `.gitignore`)
- Consider using AWS IAM roles instead of access keys when deploying to AWS
- The application runs with `debug=True` by default - **disable this in production**
- Use Docker secrets or environment variable management tools for production

## 📦 Image Management

### List images
```bash
docker images | grep aws-dashboard
```

### Remove container
```bash
docker stop aws-dashboard
docker rm aws-dashboard
```

### Remove image
```bash
docker rmi aws-dashboard:latest
```

### Tag and push to registry
```bash
docker tag aws-dashboard:latest your-registry/aws-dashboard:latest
docker push your-registry/aws-dashboard:latest
```

## 🚀 Production Deployment

For production deployment, consider:

1. **Disable debug mode**: Modify `app.py` to set `debug=False` or make it configurable via environment variable
2. **Use process manager**: Consider using `gunicorn` or `uwsgi` instead of Flask's development server
3. **Add health checks**: Implement health check endpoints
4. **Use secrets management**: Use Docker secrets, AWS Secrets Manager, or similar
5. **Container orchestration**: Deploy to Kubernetes, ECS, or similar platforms
6. **Monitoring**: Add logging and monitoring solutions

## 📚 Related Documentation

- Main project README: [../README.md](../README.md)
- Local Python app: [../python/app.py](../python/app.py)
- Terraform infrastructure: [../terraform/aws/README.md](../terraform/aws/README.md)
