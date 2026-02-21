# Using instructor's baseline image
FROM yanivomc/jenkins-slave:baseline-2.0
# allow to install packages in the system
RUN python3 -m pip config set global.break-system-packages true 
RUN pip install --upgrade api4jenkins requests flake8 bandit

# Install ShellCheck (for shell script linting)
RUN apt-get update && \
    apt-get install -y wget && \
    wget -qO- "https://github.com/koalaman/shellcheck/releases/download/stable/shellcheck-stable.linux.x86_64.tar.xz" | tar -xJv && \
    mv shellcheck-stable/shellcheck /usr/local/bin/ && \
    rm -rf shellcheck-stable && \
    rm -rf /var/lib/apt/lists/*

# Install Hadolint (for Dockerfile linting)
RUN wget -qO /usr/local/bin/hadolint "https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64" && \
    chmod +x /usr/local/bin/hadolint

# Install Trivy (for container security scanning)
RUN install -m 0755 -d /etc/apt/keyrings && \
    wget -qO- https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor -o /etc/apt/keyrings/trivy.gpg && \
    chmod a+r /etc/apt/keyrings/trivy.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/trivy.list > /dev/null && \
    apt-get update && \
    apt-get install -y trivy && \
    rm -rf /var/lib/apt/lists/*

#RUN curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose
RUN mkdir -p /home/jenkins
RUN mkdir -p /var/lib/jenkins

# Start-up script to attach the slave to the master
COPY slave.py /var/lib/jenkins/slave.py

WORKDIR /home/jenkins

ENV JENKINS_URL "http://jenkins:8080"
ENV JENKINS_SLAVE_ADDRESS ""
ENV JENKINS_USER "admin"
ENV JENKINS_PASS "admin1234"
ENV SLAVE_NAME ""
ENV SLAVE_SECRET ""
ENV SLAVE_EXECUTORS "8"
ENV SLAVE_LABELS "docker"
ENV SLAVE_WORKING_DIR ""
ENV CLEAN_WORKING_DIR "false"

CMD [ "python3", "-u", "/var/lib/jenkins/slave.py" ]
