FROM golang:1.21-alpine AS build
WORKDIR /src
COPY . .
RUN go build -o /app . || true
FROM alpine:3.19
COPY --from=build /app /app
EXPOSE 8080
CMD ["/app"]
