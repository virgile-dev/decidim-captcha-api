FROM alpine:latest as builder
RUN apk add -u crystal shards libc-dev
WORKDIR /src
COPY ./src/app.cr .
RUN crystal build --release --static ./src/app.cr -o /dist/app

FROM busybox
WORKDIR /app
EXPOSE 8080
ENV PORT 8080
COPY --from=builder /dist/app /app/app
CMD ["./app"]
