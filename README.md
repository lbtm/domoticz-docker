# domoticz-docker [![Actions Status](https://github.com/lbtm/domoticz-docker/workflows/domoticz-docker-build/badge.svg)](https://github.com/lbtm/domoticz-docker/actions)
===============

Dockerfile for domoticz - Home Automation System

# Requirement 
## Install docker >= 18.09.x
Have docker install on your local machine.  
Refer to docker installation page :   
* Fedora : https://docs.docker.com/install/linux/docker-ce/fedora/  
* Ubuntu : https://docs.docker.com/install/linux/docker-ce/ubuntu/

# Get Dockerfile 
```bash
git clone https://github.com/lbtm/domoticz-docker.git
```

# Build domoticz docker image
```bash
cd domoticz-docker
docker build -t mydomoticz .
```

# Run domoticz
```bash
docker run -p 8080:8080 -d mydomoticz
```

# Browsing
 * Open your favorite browser http://127.0.0.1:8080
