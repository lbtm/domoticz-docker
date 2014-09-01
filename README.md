domoticz-docker
===============

Dockerfile for domoticz

Requirements
===
 * Docker: https://www.docker.io/gettingstarted/#h_installation

Getting domoticz Docker files
===
 * From GitHub : git clone https://github.com/lbtm/domoticz-docker.git

Building
===
 * cd domoticz-docker
 * docker.io build -t MyDomoticz .

Running
===
docker.io run -p 8080:8080 -d MyDomoticz

Browsing
===
 * Open your favorite browser http://127.0.0.1:8080
