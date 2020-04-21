# Building app with golang container
FROM golang:1.13-alpine as builder

RUN apk --no-cache --no-progress add git make ca-certificates tzdata\
    && rm -rf /var/cache/apk/*

WORKDIR /go/traefik-migration-tool

# Download go modules
COPY go.mod .
COPY go.sum .
RUN GO111MODULE=on GOPROXY=https://proxy.golang.org go mod download

COPY . .

RUN make build

## IMAGE
FROM alpine:3.10

RUN apk --no-cache --no-progress add ca-certificates tzdata\
    && rm -rf /var/cache/apk/*

COPY --from=builder /go/traefik-migration-tool/traefik-migration-tool .
WORKDIR /data

ENTRYPOINT ["/traefik-migration-tool"]
CMD ["-h"]
