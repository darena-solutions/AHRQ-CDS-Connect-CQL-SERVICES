FROM node:22-alpine

ARG TARGETARCH
ARG NODE_ENV
ENV NODE_ENV $NODE_ENV

# First copy over the npm files and install dependencies (multi-stage build optimization)
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY ./package.json .
COPY ./npm-shrinkwrap.json .
RUN npm install --omit=dev

# Now copy over the remaining relevant files
COPY ./bin /usr/src/app/bin
COPY ./lib /usr/src/app/lib
COPY ./public /usr/src/app/public
COPY ./routes /usr/src/app/routes
COPY ./views /usr/src/app/views
COPY ./app.js /usr/src/app/app.js
RUN mkdir -p /usr/src/app/config
RUN chown node /usr/src/app/config
RUN mkdir -p /usr/src/app/config/libraries
RUN chown node /usr/src/app/config/libraries
RUN mkdir -p /usr/src/app/config/hooks
RUN chown node /usr/src/app/config/hooks
RUN mkdir -p /usr/src/app/.vsac_cache
RUN chown node /usr/src/app/.vsac_cache

# Clean up a bit to save space
RUN npm cache clean --force

# Expose the server port
EXPOSE 3000
EXPOSE 80

# Create a volume for the VSAC cache
VOLUME ["/usr/src/app/.vsac_cache"]

# Run using the node user (otherwise runs as root, which is security risk)
USER node

WORKDIR /usr/src/app
CMD [ "node", "./bin/www"]