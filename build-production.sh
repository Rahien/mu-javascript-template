#!/bin/bash

# Builds sources in production
#
# We want to compare the used sources from the one available in /source
# so we can warn at runtime in case developers accidentally mount
# sources without setting the development environment variable.

# Copy sources from /app to where they can be built
cd /app
rm -rf /build
mkdir /build
cp -r /app /build

mkdir -p /config /config.original

if [[ "$(ls -A /app/config/ 2> /dev/null)" ]]
then
    cp -r /app/config/* /config.original/
    cp -r /app/config/* /config/
fi

cp -r /app /app.original

# Install custom packages if need be
if [ -f /build/package.json ]
then
    echo "Running npm install"
    cd /build/
    npm install
    cd /build/
fi

./transpile-sources.sh
