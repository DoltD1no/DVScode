# VS Code with Root Access - Simple & Clean
FROM ubuntu:22.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV PORT=10000

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
        npm && \
    curl -fsSL https://code-server.dev/install.sh | sh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create workspace and config directories
RUN mkdir -p /workspace /root/.config/code-server

# Setup useful bash aliases for root
RUN echo 'alias ll="ls -la"' >> /root/.bashrc && \
    echo 'alias update="apt update"' >> /root/.bashrc && \
    echo 'alias install="apt install -y"' >> /root/.bashrc && \
    echo 'echo "👑 VS Code as ROOT - Full access available"' >> /root/.bashrc

# Set working directory
WORKDIR /workspace

# Expose port
EXPOSE $PORT

# Start code-server as root with password from environment
CMD echo "🚀 Starting VS Code as ROOT" && \
    echo "🔐 Password: $PASSWORD" && \
    echo "🔗 Port: $PORT" && \
    code-server \
        --bind-addr "0.0.0.0:$PORT" \
        --auth password \
        --disable-telemetry \
        /workspace
