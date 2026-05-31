ARG CADDY_VERSION=2.11.3
ARG GO_VERSION=1.26

FROM golang:${GO_VERSION} AS builder

ARG CADDY_VERSION

ENV CGO_ENABLED=0

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

RUN xcaddy build v${CADDY_VERSION} \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
    --with github.com/pberkel/caddy-storage-redis

FROM caddy:${CADDY_VERSION}-alpine

COPY --from=builder /go/caddy /usr/bin/caddy

CMD ["caddy", "docker-proxy"]
