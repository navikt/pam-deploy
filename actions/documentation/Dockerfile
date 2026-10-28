FROM cgr.dev/chainguard/go:latest-dev@sha256:d18874e434e82e2679a7ee96d9e6445fa395896caf95ebb168b7e5ca11d38ef5 AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /naisparser


FROM cgr.dev/chainguard/wolfi-base@sha256:31cfe087eb48bde827a6e0f607a12865f6f37d89093b95b324b9d5714e3cedab

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY --from=build /naisparser /go/naisparser

ENTRYPOINT ["/entrypoint.sh"]
