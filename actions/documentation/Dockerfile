FROM cgr.dev/chainguard/go:latest-dev@sha256:81cdf3facd4aa954fa208b8079156310807f33c39d11dcb23d99b4d6d8552550 AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /naisparser


FROM cgr.dev/chainguard/wolfi-base@sha256:3754b6da0e1ccdab0fe46abfdd7bbbba994b593c28149f6659fa6597f2261aeb

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY --from=build /naisparser /go/naisparser

ENTRYPOINT ["/entrypoint.sh"]
