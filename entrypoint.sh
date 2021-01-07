#!/bin/sh

wget $LICENCES_URL -O /etc/lmgrd/licenses/licenses.zip
unzip /etc/lmgrd/licenses/licenses.zip && rm -vf /etc/lmgrd/licenses/licenses.zip

# This will exec the CMD from your Dockerfile, i.e. "npm start"
exec "$@"

