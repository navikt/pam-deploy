FROM cgr.dev/chainguard/go:latest-dev@sha256:c37e08ef2ce5b8ec0615f044062549ecda5069f0df81a9aafbd2eef112a361a5 AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /naisparser


FROM cgr.dev/chainguard/wolfi-base@sha256:d13acb327aa77acf2752acea8c08456511a5b8142455cc2fe0f966b960bf64c6

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY --from=build /naisparser /go/naisparser

ENTRYPOINT ["/entrypoint.sh"]
