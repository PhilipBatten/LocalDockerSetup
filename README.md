# LocalDockerSetup
 Basic Docker setup for a web application (Go or similar)

Components:
- local domain name via nginx proxy and hosts entry
- database and redis available to application
- makefile for easy starting application

Hosts '/etc/hosts':
```
172.41.0.2 app.name.local 
```

172.41.0.2 is the IP in the docker compose setup for the nginx proxy

Run the application:
- `make start` - runs with docker build
- `make fast` - runs without docker build

postgres available at localhost:5432
redis available at localhost:6379

Application available in browser with http://app.name.local
