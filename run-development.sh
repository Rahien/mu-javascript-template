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
mkdir -p /app /build/src
rm -rf /build/src
mkdir -p /build/src

docker-rsync --exclude 'node_modules' /app/ /build/src/

cd /build/
rm -rf /build/src/dist



######################
# Install dependencies
######################

## Check if package.json existed and did not change since previous build (/usr/src/app/app/ is copied later in this script, at first run from the template itself it doesn't exist but that's fine for comparison)
cmp -s /check/package.json /app/package.json
CHANGE_IN_PACKAGE_JSON="$?"

## Copy config folder
if [[ "$(ls -A /config/ 2> /dev/null)" ]]
then
    mkdir -p /build/src/config
    cp -rf /config/* /build/src/config/
fi

## Install dependencies on first boot
if [ $CHANGE_IN_PACKAGE_JSON != "0" ] && [ -f /app/package.json ]
then
    echo "Running npm install"
    cp /app/package.json /build/package.json
    npm install
    rm -rf /check
    mkdir /check
    cp /app/package.json /check/package.json
    echo "npm install done"
fi

echo "copying template modules..."
# template node modules should take priority over package modules
# and if there are no package modules, this way we at least have the template ones
docker-rsync --ignore-existing /template/node_modules/ /build/node_modules/
echo "template modules copied"

###############
# Transpilation
###############

echo "transpiling..."
/template/transpile-sources.sh


##############
# Start server
##############

cd /build/
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
