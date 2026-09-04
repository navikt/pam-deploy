FROM cgr.dev/chainguard/go:latest-dev@sha256:483c9458b00c90684e627280ae19d9fed336ec4fe55d9d5fa4971dfd59c5981a AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /naisparser


FROM cgr.dev/chainguard/wolfi-base@sha256:103eb3f4444c68ea2453bf3aad09d860eaa5a698effb3e656cd607f630f0e46d

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY --from=build /naisparser /go/naisparser

ENTRYPOINT ["/entrypoint.sh"]
