FROM crystallang/crystal
WORKDIR /src
EXPOSE 8080
ENV PORT 8080
COPY api.cr .
RUN crystal build api.cr -p
CMD ["./api"]
