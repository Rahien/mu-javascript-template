#!/bin/bash

# Builds sources in production
#
# We want to compare the used sources from the one available in /app/src/
# so we can warn at runtime in case developers accidentally mount
# sources without setting the development environment variable.

# Copy sources from /app to where they can be built
cd /app
rm -rf /app/dist
mkdir /app/dist

mkdir -p /config /config.original

if [[ "$(ls -A /app/config/ 2> /dev/null)" ]]
then
    cp -r /app/config/* /config.original/
    cp -r /app/config/* /config/
fi

cp -r /app /app.original

# Install custom packages if need be
if [ -f /app/src/package.json ]
then
    echo "Running npm install"
    cd /app/
    cp /app/src/package.json /app/package.json
    npm install
fi

# add node modules from template back in
docker-rsync /template/node_modules/ /app/node_modules/

/template/transpile-sources.sh
