FROM cgr.dev/chainguard/go:latest-dev@sha256:9b20546aae743fadb0adb5b4801188b79061de7299f074d82ca6c939c7f80772 AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /naisparser


FROM cgr.dev/chainguard/wolfi-base@sha256:28c39be5a5e1e9b85081c10740e8495f6518a865b23bc6a486637c4b21e74b43

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY --from=build /naisparser /go/naisparser

ENTRYPOINT ["/entrypoint.sh"]
