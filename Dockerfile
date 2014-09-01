#
# Domoticz Dockerfile
#
# https://github.com/lbtm/domoticz-docker
#

# Pull base image.
FROM debian
MAINTAINER LBTM

# Install Domoticz from sources.
RUN \
  apt-get update && \
  apt-get install -y cmake apt-utils build-essential && \
  apt-get install -y libboost-dev libboost-thread-dev libboost-system-dev libsqlite3-dev subversion curl libcurl4-openssl-dev libusb-dev zlib1g-dev

# Define working directory.
WORKDIR /root/

# Getting the source code
RUN \
  svn checkout svn://svn.code.sf.net/p/domoticz/code/domoticz && \
  cd domoticz && cmake CMakeLists.txt && \
  make

# DAEMON path
RUN sed -i s'/DAEMON=\/home\/pi\/domoticz\/domoticz/DAEMON=\/root\/domoticz\/domoticz/' domoticz/domoticz.sh

# Init Unix startup script
RUN \
  cp domoticz/domoticz.sh /etc/init.d/domoticz && \
  chmod +x /etc/init.d/domoticz && \
  update-rc.d domoticz defaults

# Clean up APT when done.
RUN apt-get clean

# Expose port.
EXPOSE 8080

CMD ["/root/domoticz/domoticz", "-www 8080"]
