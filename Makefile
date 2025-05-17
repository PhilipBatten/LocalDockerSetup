default: help

docker-compose=docker compose -f docker-compose.yml -f docker-compose.override.yml

help:
	@echo ""
	@echo "Available environment commands:"
	@echo "    fast   bring up the development environment WITHOUT npm and composer installs"
	@echo "    start  bring up the development environment WITH npm and composer installs"
	@echo "    stop   stop the development environment and clear up containers and network"
	@echo ""
	@echo "Available application commands:"
	@echo "    go_test  run the unit tests"
	@echo "    go_test_this  run a specific test with a filter, e.g., make go_test_this f=TestName"
	@echo ""

# Development Environment Commands
fast: stop _start _finish

start: git stop _build _start _finish

stop:
	$(docker-compose) down -v --remove-orphans
	docker network rm frontend || true

git:
	git submodule update --force --recursive --init --remote

_build:
	$(docker-compose) pull
	$(docker-compose) build --pull

_start:
	export COMPOSE_HTTP_TIMEOUT=240
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./docker/proxy/certs/nginx.key -out ./docker/proxy/certs/nginx.crt -subj "/C=GB/ST=London/L=London/O=Alros/OU=IT Department/CN=localhost"
	# openssl req -x509 -nodes -newkey rsa:2048 -keyout docker/proxy/key.pem -out docker/proxy/cert.pem -sha256 -days 365 -subj "/C=GB/ST=London/L=London/O=Alros/OU=IT Department/CN=localhost"
	$(docker-compose) run --rm dependencies

_finish:
	@echo "Development environment up at: http://app.name.local/"
	@echo ""
	@echo "> Username: "
	@echo "> Password: "
	@echo ""

go_test:
	$(docker-compose) exec app go test -v ./...

go_test_nocache:
	$(docker-compose) exec app go clean -testcache && $(docker-compose) exec app go test -v ./...

go_coverage:
	$(docker-compose) exec app go test -v -coverpkg=./... -coverprofile=profile.cov ./...
	$(docker-compose) exec app sed -i '/mocks/d' ./profile.cov
	$(docker-compose) exec app go tool cover -func profile.cov

go_lint:
	docker run -t --rm -v $$(pwd):/app -w /app golangci/golangci-lint:latest golangci-lint run ./... -v

templ_generate:
	$(docker-compose) exec app /go/bin/templ generate

sqlc_generate:
	$(docker-compose) exec app sqlc generate

go_test_this:
	$(docker-compose) exec app go test -p 1 ./... -v --run $(f)
