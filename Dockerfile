FROM crystallang/crystal:latest as builder
WORKDIR /workdir
COPY ./src/app.cr .
RUN mkdir dist
RUN crystal build --release --static app.cr -o ./dist/app

FROM busybox
WORKDIR /app
EXPOSE 8080
ENV PORT 8080
COPY --from=builder /workdir/dist/app /app/app
CMD ["./app"]
