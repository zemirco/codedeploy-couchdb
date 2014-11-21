#!/bin/bash

# replace local.ini with our custom one
cp /tmp/local.ini /usr/local/etc/couchdb/

# change ownership of CouchDB directories
chown -R couchdb:couchdb /usr/local/etc/couchdb
chown -R couchdb:couchdb /usr/local/var/lib/couchdb
chown -R couchdb:couchdb /usr/local/var/log/couchdb
chown -R couchdb:couchdb /usr/local/var/run/couchdb

# change permission of CouchDB directories
chmod 0770 /usr/local/etc/couchdb
chmod 0770 /usr/local/var/lib/couchdb
chmod 0770 /usr/local/var/log/couchdb
chmod 0770 /usr/local/var/run/couchdb

# create symbolic link between files
sudo ln -s /usr/local/etc/init.d/couchdb  /etc/init.d

# install CouchDB as a service and allow it to start on boot
sudo update-rc.d couchdb defaults
