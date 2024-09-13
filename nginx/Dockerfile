  # Use the official Nginx image
FROM nginx:alpine

RUN apk add --no-cache openssl bash

# Copy Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy SSL certificates
COPY ./nginx.conf /etc/nginx/nginx.conf
    
# Expose port 443 for HTTPS
EXPOSE 443
