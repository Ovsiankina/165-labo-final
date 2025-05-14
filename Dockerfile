# Use a minimal Debian slim base image
FROM debian:bullseye-slim

# Install required packages
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    ca-certificates

# Import MongoDB public GPG key
RUN wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | apt-key add -

# Create the MongoDB source list file for the community edition
RUN echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/debian bullseye/mongodb-org/6.0 main" \
    | tee /etc/apt/sources.list.d/mongodb-org-6.0.list

# Install MongoDB Community Edition and its outils
RUN apt-get update && apt-get install -y mongodb-org && rm -rf /var/lib/apt/lists/*

# Create data directories
RUN mkdir -p /data/db
# /data/db2

# Expose MongoDB default port
EXPOSE 27017
# EXPOSE 27018

# Define a volume to persist database files (toute la hiérarchie /data sera persistée)
VOLUME ["/data"]

# Démarrage initial en mode standalone (dbpath par défaut : /data/db)
CMD ["mongod", "--auth", "--bind_ip_all"]
