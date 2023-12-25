#!/bin/bash

source /template/helpers.sh

####
#### BUILDS SOURCES
####
#### Expects sources to be in /usr/src/app/ with the app in
#### /usr/src/app/app/ and stores the resulting build in /usr/src/build

# Clean starting state
# rm -Rf /processing /dist

# # Copy template (/usr/src/app/) and app (/usr/src/app/app/) sources
# # without package.json, which we want to skip as it would conflict
# # building sources.

# cp -R /template /processing
# rm -f /processing/app/package.json


# ## CoffeeScript
# ##
# ## Coffeescript is transpiled ready for nodejs.  This is then moved into
# ## app so we have the javascript available which other preprocessors may
# ## expect to exist.
# ##
# ## In order to generate the sourcemaps correctly, it seems we have to be
# ## next to the folder where we want the sources to land, but in order to
# ## transpile correctly we also need the node_modules for babel and the
# ## babelrc file.  We temporarily move those around.

# # prepare the build folders
# mkdir /dist /build.coffee
# cp -R /processing/app/* /usr/src/build/
# cp /usr/src/processing/babel.config.json /usr/src/
# cp -R /usr/src/processing/node_modules/ /usr/src/

# # make the build and move to coffeescript-transpilation
# /usr/src/app/node_modules/.bin/coffee -M -m --compile -t --output ./build.coffee/ ./build
# mv build.coffee/ /usr/src/processing/coffeescript-transpilation

# # clean up
# rm -Rf /usr/src/build /usr/src/node_modules/
# rm /usr/src/babel.config.json

## TypeScript and ES6
##
## Transpiles TypeScript and ES6 to something nodejs wants to run.
cd /template

/template/node_modules/.bin/babel \
  /app/src \
  --out-dir /app/dist/ \
  --source-maps "true" \
  --extensions ".ts,.js"

# # We move the coffeescript files again because the previous step will
# # have built the sources coffeescript generated, but these sources were
# # already node compliant.  We could make coffeescript emit ES6 and
# # transpile them to nodejs in this step, but that breaks SourceMaps.
# docker-rsync /usr/src/processing/coffeescript-transpilation/ /usr/src/build/
