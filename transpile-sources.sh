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


## CoffeeScript
##
## Coffeescript is transpiled ready for nodejs.  This is then moved into
## app so we have the javascript available which other preprocessors may
## expect to exist.
##

# our babel config is in /template let's run all commands from there
# and use absolute paths
cd /template

# build coffeescript (note: don't use -M as it seems vscode is confused about inline sourcemaps)
# chrome still happily works with .map files too though so we're all good!
/template/node_modules/.bin/coffee -m --compile -t --output /app/dist /app/src

## TypeScript and ES6
##
## Transpiles TypeScript and ES6 to something nodejs wants to run.

/template/node_modules/.bin/babel \
  /app/src \
  --out-dir /app/dist/ \
  --source-maps "true" \
  --extensions ".ts,.js"

