#!/bin/sh

wget $LICENSE_URL -O $LICENSE_DIR/license.lic

#sleep 300

# This will exec the CMD from your Dockerfile, i.e. "npm start"
exec "$@"
