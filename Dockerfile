# VS Code with Root Access - Simple & Stable
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PORT=8000

# Install minimal required packages
RUN apt-get update && \
    apt-get install -y curl wget git vim nano build-essential ca-certificates && \
    curl -fsSL https://code-server.dev/install.sh | sh && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create workspace
RUN mkdir -p /workspace && \
    echo '# VS Code Workspace' > /workspace/README.md && \
    echo 'console.log("Hello World!");' > /workspace/app.js

# Simple aliases
RUN echo 'alias ll="ls -la"' >> /root/.bashrc

WORKDIR /workspace
EXPOSE $PORT

# Simple, direct startup - no complex process management
CMD echo "🚀 Starting VS Code as ROOT" && \
    echo "🔐 Password: $PASSWORD" && \
    echo "🔗 Port: $PORT" && \
    code-server \
        --bind-addr "0.0.0.0:$PORT" \
        --auth password \
        --disable-telemetry \
        --log warn \
        /workspace
