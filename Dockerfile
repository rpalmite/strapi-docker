FROM node:11.1.0-alpine

LABEL maintainer="Luca Perret <perret.luca@gmail.com>" \
      org.label-schema.vendor="Strapi" \
      org.label-schema.name="Strapi Docker image" \
      org.label-schema.description="Strapi containerized" \
      org.label-schema.url="https://strapi.io" \
      org.label-schema.vcs-url="https://github.com/strapi/strapi-docker" \
      org.label-schema.version=latest \
      org.label-schema.schema-version="1.0"


ENV APP_NAME strapi-app
ENV DATABASE_CLIENT mongo 
ENV DATABASE_HOST mongo-cluster-jn3ix.gcp.mongodb.net 
ENV DATABASE_PORT 27017 
ENV DATABASE_NAME strapi2
ENV DATABASE_SRV true
ENV DATABASE_USERNAME strapi
ENV DATABASE_PASSWORD strapi

WORKDIR /usr/src/api

RUN echo "unsafe-perm = true" >> ~/.npmrc

RUN npm install -g strapi@alpha

COPY strapi.sh ./
RUN chmod +x ./strapi.sh

EXPOSE 1337

COPY healthcheck.js ./
HEALTHCHECK --interval=15s --timeout=5s --start-period=30s \
      CMD node /usr/src/api/healthcheck.js

CMD ["./strapi.sh"]
