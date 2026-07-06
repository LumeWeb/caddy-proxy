ARG CADDY_VERSION=2.11.4
ARG GO_VERSION=1.26
ARG CADDY_DOCKER_PROXY_VERSION=v2.12.1

FROM golang:${GO_VERSION} AS builder

ARG CADDY_VERSION
ARG CADDY_DOCKER_PROXY_VERSION

ENV CGO_ENABLED=0

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

RUN xcaddy build v${CADDY_VERSION} \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2@${CADDY_DOCKER_PROXY_VERSION} \
    --with github.com/pberkel/caddy-storage-redis \
    --with github.com/xorfox-llc/caddy-otlp-logs \
    --with go.lumeweb.com/caddy_profiling

FROM caddy:${CADDY_VERSION}-alpine

COPY --from=builder /go/caddy /usr/bin/caddy

CMD ["caddy", "docker-proxy"]
