FROM golang:1.21-alpine
WORKDIR /src
COPY . .
EXPOSE 8080
CMD ["sh","-c","sleep 1"]
