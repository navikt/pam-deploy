FROM cgr.dev/chainguard/go:latest-dev@sha256:21ff0d6057c5f70e7f37100f99886164a9279355426e78f34d75548bd5d642a8 AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /naisparser


FROM cgr.dev/chainguard/wolfi-base@sha256:c902a861151182e4ce2de29b8632ba3f7d75b68c35880580f16e353819e524d3

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY --from=build /naisparser /go/naisparser

ENTRYPOINT ["/entrypoint.sh"]
