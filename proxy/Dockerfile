# Use the official Nginx image
FROM nginx:alpine
RUN apk add --no-cache openssl bash
# Copy Nginx configuration
COPY ./nginx.conf /etc/nginx/nginx.conf
# Copy SSL certificates
CMD ["nginx", "-g", "daemon off;"]
EXPOSE 443