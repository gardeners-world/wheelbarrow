PROJECT = $(shell git remote -v | grep origin | grep fetch | sed "s:.*/\(.*\)\.git .*:\1:")
PROJECT = wheelbarrow
ID = pikesley/${PROJECT}

all: build

build:
	docker build --no-cache -t ${ID} .

push:
	docker push ${ID}

run:
	docker-compose exec whe${PROJECT}elbarrow bash

