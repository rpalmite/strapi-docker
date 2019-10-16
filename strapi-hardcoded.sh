#!/bin/sh
set -ea

_stopStrapi() {
  echo "Stopping strapi"
  kill -SIGINT "$strapiPID"
  wait "$strapiPID"
}

trap _stopStrapi SIGTERM SIGINT

cd /usr/src/api

APP_NAME=${APP_NAME:-strapi-app}
DATABASE_CLIENT=${DATABASE_CLIENT:-mongo}
DATABASE_HOST=${DATABASE_HOST:-mongo-cluster-jn3ix.gcp.mongodb.net}
DATABASE_PORT=${DATABASE_PORT:-27017}
DATABASE_NAME=${DATABASE_NAME:-strapi}
DATABASE_SRV=${DATABASE_SRV:-true}
EXTRA_ARGS=${EXTRA_ARGS:-}

DATABASE_USERNAME=strapi
DATABASE_PASSWORD=strapi

if [ ! -f "$APP_NAME/package.json" ]
then
    strapi new strapi-app --dbclient=mongo --dbhost=mongo-cluster-jn3ix.gcp.mongodb.net --dbport=27017 --dbsrv=true --dbname=strapi2 --dbusername=strapi --dbpassword=strapi --dbssl=true --dbauth=admin $EXTRA_ARGS

elif [ ! -d "$APP_NAME/node_modules" ]
then
    npm install --prefix ./$APP_NAME
fi

cd $APP_NAME
strapi start &

strapiPID=$!
wait "$strapiPID"
