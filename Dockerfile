# Base image: Python Alpine version for a lightweight image
FROM python:3.9-alpine

# Install dependencies (openssl for certificate generation)
RUN apk add --no-cache openssl

# Set environment variables to run the app as non-root user
ENV USER=nonrootuser
ENV UID=1000
ENV GID=1000

# Create a non-root user and set up directories
RUN addgroup -g ${GID} ${USER} && adduser -D -u ${UID} -G ${USER} ${USER}

# Set the working directory
WORKDIR /app

# Copy application files to the container
COPY server.py /app

# Generate self-signed certificates
RUN openssl req -x509 -newkey rsa:4096 -keyout /app/key.pem -out /app/cert.pem -days 365 -nodes -subj "/CN=localhost"

# Set permissions for the certificates
RUN chown -R ${USER}:${USER} /app

# Change user to non-root
USER ${USER}

# Expose port 4443 for secure web server
EXPOSE 4443

# Command to run the server
CMD ["python", "server.py"]
