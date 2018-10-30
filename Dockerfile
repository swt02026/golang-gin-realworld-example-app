# build stage
FROM golang:alpine AS build-env
RUN set -eux; \
    apk add --no-cache --virtual .build-deps \
    git gcc libc-dev; \
    go get -u github.com/kardianos/govendor; \
    go get -u github.com/pilu/fresh; \
    go get -u golang.org/x/crypto/... ;
# apk del .build-deps;
ADD . /go/src/github.com/wangzitian0/golang-gin-starter-kit
ENV GOPATH /go
ENV GOROOT /usr/local/go
WORKDIR /go/src/github.com/wangzitian0/golang-gin-starter-kit
RUN govendor sync;
RUN govendor add +external
RUN go build

# final stage
FROM alpine
WORKDIR /app
COPY --from=build-env /go/src/github.com/wangzitian0/golang-gin-starter-kit/golang-gin-starter-kit /app/
ENTRYPOINT ./golang-gin-starter-kit