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
  # Remove any previous Boost installation
  apt remove --purge --auto-remove -y libboost-dev libboost-thread-dev libboost-system-dev libboost-atomic-dev libboost-regex-dev libboost-chrono-dev && \
  apt-get clean

# Define working directory.
WORKDIR /root/

# Install CMake
RUN \ 
  wget https://github.com/Kitware/CMake/releases/download/v3.16.2/cmake-3.16.2.tar.gz && \
  tar -xzf cmake-3.16.2.tar.gz && \
  rm cmake-3.16.2.tar.gz && cd cmake-3.16.2 && \
  ./bootstrap && \
  make && \
  make install && \
  cd .. && rm -Rf cmake-3.16.2

# Install Boost
RUN \ 
  wget https://dl.bintray.com/boostorg/release/1.71.0/source/boost_1_71_0.tar.gz && \
  tar xfz boost_1_71_0.tar.gz && \
  cd boost_1_71_0/ && \
  ./bootstrap.sh && \ 
  ./b2 stage threading=multi link=static --with-thread --with-system && \
  ./b2 install threading=multi link=static --with-thread --with-system && \
  cd .. && rm -Rf boost_1_71_0

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
