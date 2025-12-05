# Dockerfile för Ignition 8.3.1 på Raspberry Pi 5 (headless)
# Using Docker Official Image for ARM64 (recommended by Balena since balenalib is deprecated)
FROM arm64v8/debian:bullseye

# Installera OpenJDK 11 och systempaket
RUN apt-get update && apt-get install -y \
    openjdk-11-jre-headless \
    ca-certificates \
    procps \
    util-linux \
    && rm -rf /var/lib/apt/lists/*

# Skapa arbetskatalog
WORKDIR /opt/ignition

# Kopiera Ignition-filerna från den extraherade zip-mappen
COPY Ignition-linux-aarch-64-8.1.50/ /opt/ignition/

# Kopiera modules (MQTT Engine) direkt in i imagen
COPY modules/*.modl /opt/ignition/user-lib/modules/
RUN chmod +x /opt/ignition/ignition.sh

# Sätt JVM heap-max till 2 GB
RUN sed -i 's/wrapper.java.maxmemory=.*/wrapper.java.maxmemory=2048/' /opt/ignition/data/ignition.conf

# Kopiera startup-script (som sätter CPU governor + swap)
COPY startup.sh /opt/ignition/startup.sh
RUN chmod +x /opt/ignition/startup.sh

# Starta Ignition headless i foreground via startup.sh
CMD ["/opt/ignition/startup.sh"]
