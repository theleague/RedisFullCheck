#
# Resources:
#   https://hub.docker.com/_/golang
#   https://github.com/alibaba/RedisFullCheck
#
# Reset:
#   docker stop $(docker ps -a -q)
#   docker system prune -a
#
# Setup:
#   docker build --rm -t redis-full-check .
#   docker run -it --entrypoint /bin/bash redis-full-check
#
# Usage:
#   /redis-full-check -s <source_host>:6379 -t <target_host>:6379
#   sqlite3 result.db.3
#   select * from key;
#

FROM golang:latest

RUN apt-get update && apt-get install -y sqlite3

RUN echo "alias ll='ls -ltra --color'" >> /root/.bashrc

WORKDIR /go

COPY . .

RUN go get -u github.com/kardianos/govendor && \
    cd ./src/vendor && \
    GOPATH=`pwd`/../.. && \
    govendor sync && \
    cd ../../ && \
    ./build.sh

WORKDIR /go/bin
