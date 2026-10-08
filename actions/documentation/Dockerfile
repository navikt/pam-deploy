FROM cgr.dev/chainguard/go:latest-dev@sha256:1f4eb7e50fc24b6be0806bb512f9c5f0bbd8abbe63aea350c5b6e7b91a6861ea AS build

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
