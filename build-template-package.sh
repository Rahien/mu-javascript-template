mkdir /template/built-mu
cd /template
/template/node_modules/.bin/babel \
  /template/helpers/mu/ \
  --source-maps "true" \
  --out-dir /template/built-mu \
  --extensions ".js,.ts"

cp -R /template/built-mu /template/node_modules/mu
