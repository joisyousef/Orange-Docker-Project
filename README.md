We need to build an three tier application (backend,Database,proxy) with docker principles.

    - The backend docker file write in multi-stage approach.
    - The database creadential is in your host machine.
    - Make sure that proxy is up and running in https protocol and the configuration files is in your host machine.
    - Kindly make sure that each container is in seperate network.
    - Make sure that all project is up and down with one command.

Note:You will find backend files in the same path of the project.

Done!

## Compose sample application

### Go server with a Nginx proxy and a MariaDB/MySQL database

Project structure:

```
├── backend
│   ├── Dockerfile
│   ├── go.mod
│   ├── go.sum
│   └── main.go
├── compose.yaml
├── db
│   └── password.txt
├── proxy
│   ├── Dockerfile
│   └── nginx.conf
└── README.md
```

[_compose.yaml_](compose.yaml)

```yml
services:
  backend:
    build:
      context: backend
      target: builder
    secrets:
      - db-password
    depends_on:
      db:
        condition: service_healthy

  db:
    # We use a mariadb image which supports both amd64 & arm64 architecture
    image: mariadb:10-focal
    # If you really want to use MySQL, uncomment the following line
    #image: mysql:8
    command: "--default-authentication-plugin=mysql_native_password"
    restart: always
    healthcheck:
      test:
        [
          "CMD-SHELL",
          'mysqladmin ping -h 127.0.0.1 --password="$$(cat /run/secrets/db-password)" --silent',
        ]
      interval: 3s
      retries: 5
      start_period: 30s
    secrets:
      - db-password
    volumes:
      - db-data:/var/lib/mysql
    environment:
      - MYSQL_DATABASE=example
      - MYSQL_ROOT_PASSWORD_FILE=/run/secrets/db-password
    expose:
      - 3306

  proxy:
    image: nginx
    volumes:
      - type: bind
        source: ./proxy/nginx.conf
        target: /etc/nginx/conf.d/default.conf
        read_only: true
    ports:
      - 80:80
    depends_on:
      - backend

volumes:
  db-data:

secrets:
  db-password:
    file: db/password.txt
```

The compose file defines an application with three services `proxy`, `backend` and `db`.
When deploying the application, docker compose maps port 80 of the proxy service container to port 80 of the host as specified in the file.
Make sure port 80 on the host is not already being in use.

> ℹ️ **_INFO_**  
> For compatibility purpose between `AMD64` and `ARM64` architecture, we use a MariaDB as database instead of MySQL.  
> You still can use the MySQL image by uncommenting the following line in the Compose file  
> `#image: mysql:8`

## Deploy with docker compose

```shell
$ docker compose up -d
Creating network "nginx-golang-mysql_default" with the default driver
Building backend
Step 1/8 : FROM golang:1.13-alpine AS build
1.13-alpine: Pulling from library/golang
...
Successfully built 5f7c899f9b49
Successfully tagged nginx-golang-mysql_proxy:latest
WARNING: Image for service proxy was built because it did not already exist. To rebuild this image you must use `docker-compose build` or `docker-compose up --build`.
Creating nginx-golang-mysql_db_1 ... done
Creating nginx-golang-mysql_backend_1 ... done
Creating nginx-golang-mysql_proxy_1   ... done
```

## Expected result

Listing containers must show three containers running and the port mapping as below:

```shell
$ docker compose ps
NAME                           COMMAND                  SERVICE             STATUS              PORTS
nginx-golang-mysql-backend-1   "/code/bin/backend"      backend             running
nginx-golang-mysql-db-1        "docker-entrypoint.s…"   db                  running (healthy)   3306/tcp
nginx-golang-mysql-proxy-1     "/docker-entrypoint.…"   proxy               running             0.0.0.0:80->80/tcp
l_db_1
```

After the application starts, navigate to `http://localhost:80` in your web browser or run:

```shell
$ curl localhost:80
["Blog post #0","Blog post #1","Blog post #2","Blog post #3","Blog post #4"]
```

Stop and remove the containers

```shell
$ docker compose down
```

Done!

![alt text](attachments/image.png)

blog posts

![alt text](/attachments/image2.png)
