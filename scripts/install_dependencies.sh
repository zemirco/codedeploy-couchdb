#!/bin/bash

# install dependencies
sudo apt-get install build-essential -y
sudo apt-get install erlang-base-hipe -y
sudo apt-get install erlang-dev -y
sudo apt-get install erlang-manpages -y
sudo apt-get install erlang-eunit -y
sudo apt-get install erlang-nox -y
sudo apt-get install libicu-dev -y
sudo apt-get install libmozjs-dev -y
sudo apt-get install libcurl4-openssl-dev -y

# configure
./configure

# install
make && sudo make install

# create special couchdb user for CouchDB
adduser --system \
  --home /usr/local/var/lib/couchdb \
  --no-create-home \
  --shell /bin/bash \
  --group --gecos \
  "CouchDB Administrator" couchdb
