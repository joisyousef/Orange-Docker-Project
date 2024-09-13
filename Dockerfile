FROM golang:1.19 AS build-stage

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -o /backend

FROM build-stage AS run-test-stage
RUN go test -v ./...

FROM alpine AS build-release-stage

WORKDIR /

COPY --from=build-stage /backend /backend

EXPOSE 8000


ENTRYPOINT ["/backend"]