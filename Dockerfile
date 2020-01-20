#
# Domoticz Dockerfile
#
# https://github.com/lbtm/domoticz-docker
#

# Pull base image.
FROM debian:latest
MAINTAINER LBTM

# Install Domoticz from sources.
RUN \
  apt-get update && \
  apt-get install -y cmake apt-utils build-essential make gcc g++ libssl-dev git libcurl4-gnutls-dev libusb-dev python3-dev zlib1g-dev && \
  apt-get clean

# Define working directory.
WORKDIR /root/

# Getting the source code
RUN \
  git clone https://github.com/domoticz/domoticz.git && \
  cd domoticz && cmake -DCMAKE_BUILD_TYPE=Release CMakeLists.txt -DUSE_OPENSSL_STATIC="NO" && \
  make

# DAEMON path
RUN sed -i s'/DAEMON=\/home\/pi\/domoticz\/domoticz/DAEMON=\/root\/domoticz\/domoticz/' domoticz/domoticz.sh

# Init Unix startup script
RUN \
  cp domoticz/domoticz.sh /etc/init.d/domoticz && \
  chmod +x /etc/init.d/domoticz && \
  update-rc.d domoticz defaults

# Expose port.
EXPOSE 8080

# Start Domoticz
CMD ["/root/domoticz/domoticz", "-www 8080"]
