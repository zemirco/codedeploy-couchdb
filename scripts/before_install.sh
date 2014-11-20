#!/bin/bash

# secure server
# sudo apt-get update -y
# sudo apt-get upgrade -y
# sudo apt-get install fail2ban

# install dependencies
sudo apt-get install build-essential -y
sudo apt-get install erlang-base-hipe -y
sudo apt-get install erlang-dev -y
sudo apt-get install erlang-manpages -y
sudo apt-get install erlang-eunit -y
sudo apt-get install erlang-nox -y
sudo apt-get install libicu-dev -y
sudo apt-get install libmozjs185-dev -y
sudo apt-get install libcurl4-openssl-dev -y

# install couchdb
mkdir tmp
cd /tmp

# download tarball
wget http://apache.mirror.iphh.net/couchdb/source/1.6.1/apache-couchdb-1.6.1.tar.gz

# x extract, v verbose, z use zip, f filename
tar xvzf apache-couchdb-*
cd apache-couchdb-*

# script will configure CouchDB to be installed into /usr/local by default.
./configure

# install CouchDB
make && sudo make install

# create special couchdb user for CouchDB
adduser --system \
  --home /usr/local/var/lib/couchdb \
  --no-create-home \
  --shell /bin/bash \
  --group --gecos \
  "CouchDB Administrator" couchdb

# change password for couchdb user
# sudo passwd couchdb
