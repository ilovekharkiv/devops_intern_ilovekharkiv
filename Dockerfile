# Use a base image with the necessary tools (e.g., git, jq, and any other dependencies)
FROM ubuntu:latest

# Install required packages
RUN apt-get update && \
    apt-get install -y git jq

# Copy your script and .env file into the container
COPY backup.sh .
COPY .env .

# Make the script executable
RUN chmod +x ./backup.sh

# Create a directory for storing backups outside the container
VOLUME /backup

# Run the script inside the container when the container starts
CMD ["./backup.sh"]