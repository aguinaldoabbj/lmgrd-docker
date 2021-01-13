#!/bin/sh

wget $LICENSE_URL -O $LICENSE_DIR/license

if (file $LICENSE_DIR/license | grep -q Zip); 
then
    unzip $LICENSE_DIR/license -d $LICENSE_DIR
    rm -vf $LICENSE_DIR/license
else
    mv $LICENSE_DIR/license $LICENSE_DIR/license.lic
fi

#sleep 300

# This will exec the CMD from your Dockerfile, i.e. "npm start"
exec "$@"