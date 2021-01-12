#!/bin/sh

wget $LICENSE_URL -O $LICENSE_DIR/licenses

if (file $LICENSE_DIR/licenses | grep -q Zip ) ; then
    unzip $LICENSE_DIR/licenses -d $LICENSE_DIR
    rm -vf $LICENSE_DIR/licenses    
fi

sleep 300

# This will exec the CMD from your Dockerfile, i.e. "npm start"
exec "$@"

