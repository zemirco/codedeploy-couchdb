#!/bin/bash

# run as deamon
sudo /etc/init.d/couchdb start

# install CouchDB as a service and allow it to start on boot
sudo update-rc.d couchdb defaults
