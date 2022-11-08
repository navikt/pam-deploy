FROM golang:1.17-alpine as build

RUN export PATH=$PATH:/app
WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /go


FROM bash:5.0

RUN apk add --no-cache curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY --from=build /go /go

ENTRYPOINT ["/entrypoint.sh"]
