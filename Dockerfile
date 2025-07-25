# VS Code with Root Access - Fixed for Koyeb
FROM ubuntu:22.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV PORT=8000

# Install everything we need
RUN apt-get update && \
    apt-get install -y \
        curl \
        wget \
        git \
        vim \
        nano \
        htop \
        build-essential \
        python3 \
        python3-pip \
        nodejs \
        npm \
        ca-certificates && \
    curl -fsSL https://code-server.dev/install.sh | sh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create workspace with proper setup
RUN mkdir -p /workspace && \
    mkdir -p /root/.config/code-server && \
    chmod 755 /workspace && \
    chown -R root:root /workspace

# Create some default files so workspace isn't empty
RUN echo '# Welcome to VS Code as ROOT' > /workspace/README.md && \
    echo 'console.log("Hello from VS Code!");' > /workspace/hello.js && \
    echo 'print("Python works!")' > /workspace/hello.py && \
    echo '<!DOCTYPE html><html><head><title>Test</title></head><body><h1>HTML works!</h1></body></html>' > /workspace/index.html

# Setup useful bash aliases for root
RUN echo 'alias ll="ls -la"' >> /root/.bashrc && \
    echo 'alias update="apt update"' >> /root/.bashrc && \
    echo 'alias install="apt install -y"' >> /root/.bashrc && \
    echo 'echo "👑 VS Code as ROOT - Full access available"' >> /root/.bashrc && \
    echo 'echo "📁 Workspace: /workspace"' >> /root/.bashrc

# Set working directory
WORKDIR /workspace

# Expose port
EXPOSE $PORT

# Keep the process running and add error handling
CMD echo "🚀 Starting VS Code as ROOT" && \
    echo "🔐 Password: $PASSWORD" && \
    echo "🔗 Port: $PORT" && \
    echo "📁 Workspace: /workspace" && \
    ls -la /workspace && \
    exec code-server \
        --bind-addr "0.0.0.0:$PORT" \
        --auth password \
        --disable-telemetry \
        --disable-update-check \
        --verbose \
        /workspace
