#!/bin/sh

docker network create les3_network

docker run --rm -d -e POSTGRES_PASSWORD=testpass --net les3_network --name les3_postgres postgres:9.6.5
docker run --rm -d -e REDIS_PASSWORD=testpass --net les3_network --name les3_redis redis redis-server --requirepass testpass
docker run -it --rm --net les3_network -p 9000:4567 -e DB=postgresql://postgres:testpass@les3_postgres:5432 -e CACHE=redis://:testpass@les3_redis:6379/ -v /home/sashok-15/devops-intro/devops-course-2020/lesson\ 3/:/app ruby:2.6.0 ruby /app/server.rb
