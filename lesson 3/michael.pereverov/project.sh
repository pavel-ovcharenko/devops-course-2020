#!/bin/bash

POSTGRES_HOST=postgres-ma
POSTGRES_DB=db
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgrespasswd

REDIS_HOST=redis-ma
REDIS_PASSWORD=p4ssw0rd

DB="postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}/${POSTGRES_DB}"

CACHE="redis://:${REDIS_PASSWORD}@${REDIS_HOST}:6379/0"

docker network create ma-net || true

docker run -d --rm \
    --name ${POSTGRES_HOST} \
    --network=ma-net \
	-e POSTGRES_DB=${POSTGRES_DB} \
	-e POSTGRES_USER=${POSTGRES_USER} \
	-e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
	-v postgresql-data:/var/lib/postgresql/data/ \
    postgres:9.6.5-alpine

docker run -d --rm \
	--name redis-ma \
	--network=ma-net \
	redis:6.0.9-alpine \
	redis-server --requirepass ${REDIS_PASSWORD}

docker run -d --rm \
	--name ruby-ma \
	-p 9000:4567 \
	--network=ma-net \
	-e DB=${DB} \
	-e CACHE=${CACHE} \
	-v /home/mike/Documents/MA/devops-course-2020/lesson\ 3/:/usr/src/app/ \
	-w /usr/src/app \
	ruby:2.6.0 \
	ruby server.rb

# docker stop $(docker container ls -aq)
