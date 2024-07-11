# Use the official Debian slim image as a parent image
FROM debian:bookworm-slim

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y wget tar bash && \
    apt-get clean

# Add a low-level user 'litecoin'
RUN useradd -ms /bin/bash litecoin

# Working directory
WORKDIR /home/litecoin

# Download Litecoin
RUN wget https://download.litecoin.org/litecoin-0.21.3/linux/litecoin-0.21.3-x86_64-linux-gnu.tar.gz

# Untar and install Litecoin
RUN tar -xzf litecoin-0.21.3-x86_64-linux-gnu.tar.gz && \
    mv litecoin-0.21.3 /home/litecoin/litecoin && \
    rm litecoin-0.21.3-x86_64-linux-gnu.tar.gz
# Create the litecoin.conf file and set necessary permissions
RUN mkdir -p /home/litecoin/.litecoin && \
    touch /home/litecoin/.litecoin/litecoin.conf && \
    chown -R litecoin:litecoin /home/litecoin/.litecoin

# Copy the entrypoint script and set necessary permissions
COPY entrypoint.sh /home/litecoin/entrypoint.sh
RUN chmod +x /home/litecoin/entrypoint.sh && chown litecoin:litecoin /home/litecoin/entrypoint.sh

# Change ownership of all downloaded and created files to the litecoin user
RUN chown -R litecoin:litecoin /home/litecoin

# Switch to litecoin user
USER litecoin

# Set up mount point for litecoindata
VOLUME ["/home/litecoin/.litecoin"]

# Expose default Litecoin port
EXPOSE 9333

# Entry point to run the custom script
ENTRYPOINT ["/home/litecoin/entrypoint.sh"]
