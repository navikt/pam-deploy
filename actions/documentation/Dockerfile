FROM cgr.dev/chainguard/go:latest-dev@sha256:6a2514a130cfaccef779fb1b9265f51171991eeedf1fc0ddeee95940aba3ce9a AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /naisparser


FROM cgr.dev/chainguard/wolfi-base@sha256:150a90c21d962ea400988490b629e245658391b63a1f625e847f5dea50dd3094

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY --from=build /naisparser /go/naisparser

ENTRYPOINT ["/entrypoint.sh"]
