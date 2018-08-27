FROM golang:1.11rc2-alpine as base
WORKDIR /usr/src
RUN mkdir client
WORKDIR /usr/src/client
COPY ./client/* ./
RUN GOARCH=wasm GOOS=js go build -o test.wasm main.go

WORKDIR /usr/src
COPY ./server/main.go .
RUN CGO_ENABLED=0 go build -ldflags "-s -w" -o main

FROM scratch
COPY --from=base /usr/src/client/* /
COPY --from=base /usr/src/main /server
EXPOSE 8080
CMD ["/server"]