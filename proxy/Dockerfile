FROM nginx:alpine

RUN apk add --no-cache openssl bash

CMD ["/bin/bash", "-c", "nginx -g 'daemon off;'"]

EXPOSE 443