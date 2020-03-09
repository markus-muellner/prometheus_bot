FROM golang:1.11.13-alpine3.9 as builder

RUN apk update
RUN apk add --no-cache git ca-certificates make tzdata
ADD . /prometheus_bot
WORKDIR /prometheus_bot
RUN go get -d -v
RUN CGO_ENABLED=0 GOOS=linux go build -v -a -installsuffix cgo -o prometheus_bot

FROM alpine:3.9
COPY --from=builder /prometheus_bot/prometheus_bot /
RUN apk add --no-cache ca-certificates tzdata tini
USER nobody
EXPOSE 9087
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/prometheus_bot"]
