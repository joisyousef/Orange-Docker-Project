# Use the official Nginx image
FROM nginx:alpine

# Copy Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy SSL certificates
COPY ssl/ /etc/nginx/ssl/

# Expose port 443 for HTTPS
EXPOSE 443
