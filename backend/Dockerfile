# Stage 1: Build the Go binary
FROM golang:1.18 AS builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go binary with CGO_ENABLED=0 for static linking
RUN CGO_ENABLED=0 go build -o backend .

# Stage 2: Create a small image
FROM alpine:latest  

# Install required packages
RUN apk --no-cache add ca-certificates

# Copy the binary from the builder stage
COPY --from=builder /app/backend /backend

# Make sure the binary is executable
RUN chmod +x /backend

# Set the working directory
WORKDIR /

# Command to run the binary
CMD ["./backend"]