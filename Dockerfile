FROM golang as base

WORKDIR /groupsync

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

# specify go flags through environment variables
RUN go build

# update CA certificates
FROM alpine:latest as certs
RUN apk --update add ca-certificates

# application container
FROM scratch as groupsync

COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=base groupsync /

ENTRYPOINT ["/groupsync"]
