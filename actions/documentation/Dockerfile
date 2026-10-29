FROM cgr.dev/chainguard/go:latest-dev@sha256:b27e81369573af92587fa3e7c343610e9129c967adea29fc6c0ea94a449d800b AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /naisparser


FROM cgr.dev/chainguard/wolfi-base@sha256:dbcc3a4a3b1b9e68420a4742940aa6267c97e61811736a5fef0918a06ade1827

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY --from=build /naisparser /go/naisparser

ENTRYPOINT ["/entrypoint.sh"]
