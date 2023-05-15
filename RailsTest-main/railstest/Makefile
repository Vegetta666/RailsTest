PROJECT_NAME=$(shell basename $(CURDIR))
build:
	USER_ID=$$(id -u) GROUP_ID=$$(id -u) docker-compose -f docker/docker-compose.yml -p $(PROJECT_NAME) build --no-cache

console:
	USER_ID=$$(id -u) GROUP_ID=$$(id -u) docker-compose -f docker/docker-compose.yml  -p $(PROJECT_NAME)  run --rm ruby bash

dev:
	USER_ID=$$(id -u) GROUP_ID=$$(id -u) docker-compose -f docker/docker-compose.yml -p $(PROJECT_NAME)  up

stop:
	docker stop $(shell docker ps -a -q)

.PHONY: console dev
