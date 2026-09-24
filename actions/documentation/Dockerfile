FROM cgr.dev/chainguard/go:latest-dev@sha256:cf151b2ff33809a53bcc6352475bb90f269a54e1f6291c177ab726a932711411 AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /naisparser


FROM cgr.dev/chainguard/wolfi-base@sha256:b6bfe8564bb0630778b04df06b42e78acf221e9540703cfc03d040ab7f91e357

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY --from=build /naisparser /go/naisparser

ENTRYPOINT ["/entrypoint.sh"]
