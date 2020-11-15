docker network create master_lesson3



docker run --rm -d -e POSTGRES_PASSWORD=123 --net master_lesson3 --name ma_l3 postgres:9.6.5
docker run --rm -d -e REDIS_PASSWORD=123 --net master_lesson3 --name l3_redis redis redis-server --requirepass 123
docker run -it --rm --master_lesson3 -p 9000:4567 -e DB=postgresql://postgres:123@ma_l3:5432 -e CACHE=redis://:123@l3_redis:6379/ -v /home/pavel/.ssh/lesson\ 3/:/app ruby:2.6.0 ruby /app/server.rb
