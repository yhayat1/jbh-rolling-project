# Jenkins CI/CD Environment

This directory contains the Jenkins master and slave setup for running CI/CD pipelines. The environment includes a Jenkins master with a Docker-enabled slave agent.

## 📁 Contents

- `docker-compose.yml` - Docker Compose configuration for Jenkins master and slave
- `Jenkinsfile` - Pipeline configuration for the project (located at `jenkins/Jenkinsfile`)
- `master/` - Jenkins master Dockerfile and initialization scripts
- `slave/` - Jenkins slave Dockerfile and connection script
- `casc_configs/` - Configuration as Code (CasC) files

## 📋 Configuration as Code (CasC)

The `casc_configs/jenkins.yaml` file uses Jenkins Configuration as Code (CasC) to automatically configure Jenkins on startup. This file defines:

- **Security Realm**: Local user authentication (admin user)
- **Authorization Strategy**: Matrix-based permissions
- **User Permissions**: Admin user with full administrative access

**Benefits of CasC:**
- Version-controlled configuration
- Reproducible Jenkins setup
- No manual configuration needed
- Changes can be tracked in Git

The configuration is automatically applied when Jenkins starts via the `CASC_JENKINS_CONFIG` environment variable.

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose installed
- Docker daemon running
- Ports 8080 and 50000 available

### Setup

1. **Navigate to the jenkins directory**:
   ```bash
   cd jenkins
   ```

2. **Start Jenkins master and slave**:
   ```bash
   docker-compose up -d --build
   ```

3. **Wait for Jenkins to initialize** (usually 1-2 minutes):
   ```bash
   docker-compose logs -f jenkins
   ```
   Wait until you see "Jenkins is fully up and running"

4. **Access Jenkins**:
   - URL: http://localhost:8080
   - Username: `admin`
   - Password: `admin1234`

5. **Configure Docker Hub Credentials**:
   - Go to Jenkins → **Manage Jenkins** → **Credentials**
   - Under "Stores scoped to Jenkins", click **"System"**
   - Click **"Global credentials (unrestricted)"**
   - Click **"Add Credentials"** (left sidebar)
   - Configure the credential:
     - **Kind**: Username with password
     - **Scope**: Global
     - **Username**: Your Docker Hub username
     - **Password**: Your Docker Hub password or access token
     - **ID**: `dockerhub-credentials` (must match exactly)
     - **Description**: (optional) e.g., "Docker Hub credentials for image push"
   - Click **"OK"** to save
   
   **Important**: The credential ID must be exactly `dockerhub-credentials` for the pipeline to work.

6. **Create a Pipeline Job**:
   - Click "New Item"
   - Enter a name (e.g., "jbh-rolling-project-pipeline")
   - Select "Pipeline"
   - Click OK
   - In Pipeline configuration:
     - Definition: "Pipeline script from SCM"
     - SCM: Git
     - Repository URL: `https://github.com/yhayat1/jbh-rolling-project.git`
     - Branch: `*/main` (or your branch)
     - Script Path: `jenkins/Jenkinsfile`
   - Save

7. **Run the Pipeline**:
   - Click "Build Now" on your pipeline job

## 📝 Pipeline Configuration

Your pipeline configuration is stored in `jenkins/Jenkinsfile`. This file defines:
- Repository cloning
- Parallel linting and security scanning
- Docker image building
- Docker Hub push

**Important**: Before running the pipeline, update the `IMAGE_NAME` in `jenkins/Jenkinsfile` (line 8) to match your Docker Hub username:
```groovy
IMAGE_NAME = 'your-dockerhub-username/flask-aws-monitor'
```
Replace `your-dockerhub-username` with your actual Docker Hub username.

## ⚙️ Configuration

### Jenkins Master

- **Port**: 8080 (HTTP), 50000 (JNLP for agents)
- **Admin User**: `admin` / `admin1234`
- **Plugins**: Pre-installed (git, docker-workflow, credentials-binding, etc.)
- **Docker Access**: Mounts host Docker socket for Docker-in-Docker

### Jenkins Slave

- **Name**: `agent2`
- **Labels**: `docker`
- **Executors**: 8
- **Docker Access**: Mounts host Docker socket
- **Base Image**: Ubuntu 22.04 LTS (specific version for reproducibility)
- **Pre-installed Tools**:
  - Docker CLI (for building and pushing images)
  - Java (JDK) - required for Jenkins agent connection
  - Python 3 + pip (for Python-based tools)
  - Git (for repository cloning)
  - **Flake8** (Python linting)
  - **ShellCheck** (Shell script linting)
  - **Hadolint** (Dockerfile linting)
  - **Bandit** (Python security scanning)
  - **Trivy** (Container security scanning)
  - api4jenkins + requests (for slave connection script)

### Volumes

- `../volume/jenkinsmaster/` - Jenkins master persistent data (created automatically on first run)
- `../volume/` - Shared volume for slave data (created automatically on first run)
- Docker socket mounted for Docker-in-Docker support

## 🔧 Troubleshooting

**Problem**: Jenkins master won't start
- **Solution**: Check logs: `docker-compose logs jenkins`
- **Solution**: Ensure port 8080 is not in use: `lsof -i :8080`

**Problem**: Slave won't connect to master
- **Solution**: Check slave logs: `docker-compose logs jenkins-slave`
- **Solution**: Verify `JENKINS_URL` environment variable is correct
- **Solution**: Ensure master is fully initialized before slave starts

**Problem**: Docker commands fail in pipeline
- **Solution**: Verify Docker socket is mounted: `docker-compose exec jenkins-slave ls -la /var/run/docker.sock`
- **Solution**: Check Docker daemon is running on host

**Problem**: Credentials not found
- **Solution**: Verify credential ID is exactly `dockerhub-credentials` (case-sensitive)
- **Solution**: Check credentials are in the global scope (System → Global credentials)
- **Solution**: Ensure credential type is "Username with password"

## 🛑 Stopping Jenkins

```bash
# Stop containers
docker-compose down

# Stop and remove all data (clean slate)
docker-compose down -v
```

## 📚 Related Documentation

- Root project README: [../README.md](../README.md)
- Python application: [../python/README.md](../python/README.md)
- Docker setup: [../docker/README.md](../docker/README.md)
- Terraform infrastructure: [../terraform/aws/README.md](../terraform/aws/README.md)
