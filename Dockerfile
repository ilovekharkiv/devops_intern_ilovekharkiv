# Use a base image with the necessary tools (e.g., git, jq, and any other dependencies)
FROM ubuntu:latest

# Define default env vars
ENV MAX_BACKUPS=3
ENV RUN_AMOUNT=3

# Install required packages
RUN apt-get update && \
    apt-get install -y git jq openssh-client

# Copy your script and .env file into the container
COPY backup.sh .
COPY .env .

# Make the script executable
RUN chmod +x ./backup.sh

# Create a directory for storing backups outside the container
VOLUME /backup

# Configure SSH for GitHub
RUN mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh && \
    touch /root/.ssh/known_hosts && \
    ssh-keyscan github.com >> /root/.ssh/known_hosts

# Run the script inside the container when the container starts
CMD ["./backup.sh"]