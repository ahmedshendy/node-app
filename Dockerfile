FROM node:10.12.0-alpine

ARG NODE_ENV=production
ARG PORT=3000

ENV NODE_ENV $NODE_ENV
ENV PORT=$PORT

RUN apk add --update tini
# - then it should create directory /usr/src/app for app files with 'mkdir -p /usr/src/app'
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
# - Node uses a "package manager", so it needs to copy in package.json file
COPY app/package.json app/package-lock.json ./
# - then it needs to run 'npm install' to install dependencies from that file
RUN npm install && npm cache clean --force
# - to keep it clean and small, run 'npm cache clean --force' after above
# - then it needs to copy in all files from current directory g
COPY ./app /usr/src/app
HEALTHCHECK --interval=30s CMD node healthcheck.js
EXPOSE $PORT
CMD ["/sbin/tini", "--", "node", "./bin/www"]