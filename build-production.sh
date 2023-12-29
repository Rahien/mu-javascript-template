#!/bin/bash
source /template/helpers.sh

# Builds sources in production
#
# We want to compare the used sources from the one available in /app/
# so we can warn at runtime in case developers accidentally mount
# sources without setting the development environment variable.

# Copy sources from /app to where they can be built
cd /app
mkdir -p /build/dist /build/src

mkdir -p /config /config.original

if [[ "$(ls -A /config/ 2> /dev/null)" ]]
then
    cp -r /config/* /config.original/
    cp -r /config/* /build/src/config/
fi

cp -r /app /app.original
docker-rsync /app/ /build/src/

# Install custom packages if need be
if [ -f /app/package.json ]
then
    echo "Running npm install"
    cd /build/
    cp /app/package.json /build/package.json
    npm install
fi

# add node modules from template back in
docker-rsync /template/node_modules/ /build/node_modules/

/template/transpile-sources.sh
