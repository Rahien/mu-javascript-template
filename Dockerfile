FROM node:18-bookworm

LABEL maintainer="madnificent@gmail.com"

RUN apt-get update && apt-get -y upgrade && apt-get -y install git openssh-client rsync

ENV MU_SPARQL_ENDPOINT 'http://database:8890/sparql'
ENV MU_APPLICATION_GRAPH 'http://mu.semte.ch/application'
ENV NODE_ENV 'production'

ENV HOST '0.0.0.0'
ENV PORT '80'

ENV LOG_SPARQL_ALL 'true'
ENV DEBUG_AUTH_HEADERS 'true'

WORKDIR /app
RUN mkdir /template && mkdir -p /app/src
COPY package.json /template/package.json
COPY ./scripts /template/scripts
RUN cd /template && npm install
COPY . /template
RUN chmod +x /template/run-development.sh
RUN chmod +x /template/build-production.sh
RUN chmod +x /template/build-template-package.sh
RUN /template/build-template-package.sh

EXPOSE ${PORT}

CMD bash /template/boot.sh

# This stuff only runs when building an image from the template
ONBUILD RUN rm -Rf /app/src/scripts
ONBUILD ADD . /app/src
ONBUILD RUN /template/build-production.sh

ONBUILD RUN if [ -f /app/src/on-build.sh ]; \
     then \
        echo "Running custom on-build.sh of child" \
        && chmod +x /app/src/on-build.sh \
        && /bin/bash /app/src/on-build.sh ;\
     fi
