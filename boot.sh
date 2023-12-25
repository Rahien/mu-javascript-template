source /template/helpers.sh

#!/bin/bash
if [ "$NODE_ENV" == "development" ]
then
    # Run live-reload development
    exec /template/node_modules/.bin/nodemon \
         --watch /app/src \
         --watch /config \
         --ignore /app/src/dist \
         --ext js,coffee,ts,mjs,cjs,json \
         --exec /template/run-development.sh
elif [ "$NODE_ENV" == "production" ]
then
    # diff but accept items created during build process
    diff -x 'dist*' -x "node_modules" -x "package-lock.json" -x "package.json" -rq /app /app.original > /dev/null
    APP_FILES_CHANGED="$?"
    diff -rq /config /config.original > /dev/null
    CONFIG_FILES_CHANGED="$?"

    if [ ! -f /app/dist/app.js ]
    then
        echo "No built sources found.  If you mount new sources, please set the NODE_ENV=\"development\" environment variable."
        sleep 5;
        exit 1;
    elif [ $APP_FILES_CHANGED != "0" ]
    then
        echo "Built sources are not the same as sources available in /app.  If you mount new sources, please set the NODE_ENV=\"development\" environment variable."
        sleep 5;
        exit 1;
    elif [ $CONFIG_FILES_CHANGED != "0" ]
    then
        echo "Rebuilding sources to include /config."

        # move new configuration into app for transpilation
        if [[ "$(ls -A /config 2> /dev/null)" ]]
        then
            cp -Rf /config/* /app/src/config/
        fi

        # make a backup of the used configuration so we can detect changes
        rm -Rf /config.original
        mkdir /config.original
        if [[ "$(ls -A /config 2> /dev/null)" ]]
        then
            cp -Rf /config/* /config.original
        fi

        # transpile sources
        cd /app/

        # add node modules from template back in
        docker-rsync /template/node_modules/ /app/node_modules/
        ./transpile-sources.sh

        # boot transpiled sources
        cd /app/
        exec node /app/dist/app.js
    else
        cd /app/
        # add node modules from template back in
        docker-rsync /template/node_modules/ /app/node_modules/
        exec node /app/dist/app.js
    fi
fi
