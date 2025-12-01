FROM balenalib/raspberrypi5-debian:latest

# Install dependencies
RUN install_packages \
    openjdk-17-jre-headless \
    unzip \
    ca-certificates

# Create ignition user with fixed UID/GID for volume compatibility
RUN addgroup --system --gid 1000 ignition && \
    adduser --system --uid 1000 --gid 1000 ignition

# Copy the Ignition zip file (added by .resinciorc)
# The file will be available at build time via .resinciorc configuration
COPY Ignition-linux-aarch-64-8.3.2-rc2.zip /tmp/ignition.zip

# Extract and install Ignition
RUN unzip /tmp/ignition.zip -d /opt/ && \
    rm /tmp/ignition.zip && \
    mv /opt/ignition-8.3.2 /opt/ignition

# Create data and logs directories (for volume mounts)
RUN mkdir -p /opt/ignition/data /opt/ignition/logs

# Set proper permissions
RUN chown -R ignition:ignition /opt/ignition

# Create a wrapper script to ensure proper startup
RUN echo '#!/bin/bash\n\
# Wait for any initialization\n\
sleep 2\n\
# Start Ignition\n\
cd /opt/ignition\n\
exec ./ignition.sh\n\
' > /usr/local/bin/start-ignition.sh && \
    chmod +x /usr/local/bin/start-ignition.sh && \
    chown ignition:ignition /usr/local/bin/start-ignition.sh

# Switch to ignition user
USER ignition
WORKDIR /opt/ignition

# Expose ports
EXPOSE 8088 8043 8044 8000

# Start Ignition using wrapper script
CMD ["/usr/local/bin/start-ignition.sh"]

