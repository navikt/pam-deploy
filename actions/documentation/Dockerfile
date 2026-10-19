FROM cgr.dev/chainguard/go:latest-dev@sha256:8c5e682389f30e2f4152cc7404123f48a6b6808f98ac2c2519ef028c269cd7e4 AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /naisparser


FROM cgr.dev/chainguard/wolfi-base@sha256:c2a4815b6ca49b9bbafd451b4bde690d567a86b2b6b54877faac8082a7bc4296

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY --from=build /naisparser /go/naisparser

ENTRYPOINT ["/entrypoint.sh"]
