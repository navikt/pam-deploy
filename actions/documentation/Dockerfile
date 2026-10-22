FROM cgr.dev/chainguard/go:latest-dev@sha256:820b9bc89b422d39107641b858ae4caabed12fc74cfac31726e88f7306ff7827 AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /naisparser


FROM cgr.dev/chainguard/wolfi-base@sha256:bc76fa39ddd1482dd56a761b3331e03ba8f0e093ebb525618a56d014b480da88

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY --from=build /naisparser /go/naisparser

ENTRYPOINT ["/entrypoint.sh"]
