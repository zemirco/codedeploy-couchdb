#!/bin/bash

# replace local.ini with our custom one
cp /tmp/local.ini /usr/local/etc/couchdb/

# change ownership of CouchDB directories
sudo chown -R couchdb:couchdb /usr/local/etc/couchdb
sudo chown -R couchdb:couchdb /usr/local/var/lib/couchdb
sudo chown -R couchdb:couchdb /usr/local/var/log/couchdb
sudo chown -R couchdb:couchdb /usr/local/var/run/couchdb

# change permission of CouchDB directories
sudo chmod 0770 /usr/local/etc/couchdb
sudo chmod 0770 /usr/local/var/lib/couchdb
sudo chmod 0770 /usr/local/var/log/couchdb
sudo chmod 0770 /usr/local/var/run/couchdb

# create symbolic link between files
sudo ln -s /usr/local/etc/logrotate.d/couchdb /etc/logrotate.d/couchdb
sudo ln -s /usr/local/etc/init.d/couchdb /etc/init.d
