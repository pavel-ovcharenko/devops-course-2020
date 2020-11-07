#!/bin/bash

DB_CONTAINER=postgresdb
DB_NAME=postgres
DB_USER=postgres
DB_PASSWORD=dbpass
NETWORK=share-net
MAIN_DIR=${PWD%/*}

DB="postgresql://${DB_USER}:${DB_PASSWORD}@${DB_CONTAINER}/${DB_NAME}"

CACHE="redis://redis:6379/1"

docker network create ${NETWORK}

docker run -d --rm --name ${DB_CONTAINER} --net ${NETWORK} -e POSTGRES_PASSWORD=${DB_PASSWORD} postgres:9.6.5-alpine

docker run -d --rm --name redis --net ${NETWORK} redis:4-alpine

docker run --rm \
	--name ruby-server \
	-p 9000:4567 \
	--net ${NETWORK} \
	-e DB=${DB} \
	-e CACHE=${CACHE} \
	-v "${MAIN_DIR}"/:/app/ \
	ruby:2.6.0 \
	ruby /app/server.rb