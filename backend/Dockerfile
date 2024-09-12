# Stage 1: Build the Go application
FROM golang:1.19 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the backend source code to the container
COPY . .

# Build the Go application
RUN go mod tidy && go build -o backend-app .

# Stage 2: Create a minimal image for running the application
FROM alpine:latest

# Install certificates for HTTPS support
RUN apk --no-cache add ca-certificates

# Set the working directory inside the container
WORKDIR /app

# Copy the built backend binary from the builder stage
COPY --from=builder /app/backend-app /app/backend-app

# Expose port 8000 (the backend service port)
EXPOSE 8000

# Run the backend application
CMD ["./backend-app"]
