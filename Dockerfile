#
# Domoticz Dockerfile from sources.
#

# Pull base image.
FROM debian:latest
MAINTAINER LBTM

# Install packages
RUN \
  apt-get update && \
  apt-get install -y wget apt-utils build-essential make gcc g++ libssl-dev git libcurl4-gnutls-dev libusb-dev python3-dev zlib1g-dev && \
  # Remove any previous CMake installation - Need version >=3.14.0
  apt remove --purge --auto-remove cmake -y && \
  apt-get clean

# Install CMake
RUN \ 
  wget https://github.com/Kitware/CMake/releases/download/v3.16.2/cmake-3.16.2.tar.gz && \
  tar -xzvf cmake-3.16.2 && \
  rm cmake-3.16.2.tar.gz && cd cmake-3.16.2 && \
  ./bootstrap && \
  make && \
  make install && \
  cd .. && rm -Rf cmake-3.16.2

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
