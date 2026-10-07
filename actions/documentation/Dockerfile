FROM cgr.dev/chainguard/go:latest-dev@sha256:1e5b0977fb7db0d314b2b91faad65b35e2b137242f2d9f34ff5eb4e30a47772f AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /naisparser


FROM cgr.dev/chainguard/wolfi-base@sha256:238642d42c5613936474d00b900c4e65fb6f637d8991c913403ff09a09cf43a3

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY --from=build /naisparser /go/naisparser

ENTRYPOINT ["/entrypoint.sh"]
