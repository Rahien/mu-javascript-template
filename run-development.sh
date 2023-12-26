#!/bin/bash

source /template/helpers.sh

# We want to run from /app but don't want to touch that folder.
#
# - node_modules which were already available in the mounted sources
# should be taken into account but shouldn't be overwritten by a
# following npm install.
#
# - Only run npm install when the package.json has changed.

# Move to right folder
cd /app/



######################
# Install dependencies
######################

## Check if package.json existed and did not change since previous build (/usr/src/app/app/ is copied later in this script, at first run from the template itself it doesn't exist but that's fine for comparison)
cmp -s /check/package.json /app/src/package.json
CHANGE_IN_PACKAGE_JSON="$?"

## Copy config folder
if [[ "$(ls -A /config/ 2> /dev/null)" ]]
then
    mkdir -p /app/src/config/
    cp -rf /config/* /app/src/config/
fi

## Install dependencies on first boot
if [ $CHANGE_IN_PACKAGE_JSON != "0" ] && [ -f /app/src/package.json ]
then
    echo "Running npm install"
    cp /app/src/package.json /app/package.json
    npm install
    rm -rf /check
    mkdir /check
    cp /app/src/package.json /check/package.json
fi

docker-rsync /template/node_modules/ /app/node_modules/

###############
# Transpilation
###############

/template/transpile-sources.sh


##############
# Start server
##############

cd /app/
if [ "$NO_BABEL_NODE" == "true" ]
then
    echo "running without babel-node"
    node \
        --inspect="0.0.0.0:9229" \
        ./dist/app.js
else
    /template/node_modules/.bin/babel-node \
        --enable-source-maps \
        --inspect="0.0.0.0:9229" \
        ./dist/app.js
fi
