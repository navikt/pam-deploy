FROM cgr.dev/chainguard/go:latest-dev@sha256:ed70318f7b4f2e4a82e1dbc363f7a13be3a5805081f86ed9d1ec02d2694c222f AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /naisparser


FROM cgr.dev/chainguard/wolfi-base@sha256:8acb3a7694eda954b3ad4256aec3291bdd92715d7a8c030abd1a21546337b4e4

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY --from=build /naisparser /go/naisparser

ENTRYPOINT ["/entrypoint.sh"]
