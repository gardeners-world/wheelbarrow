PROJECT = $(shell git remote -v | grep origin | grep fetch | sed "s:.*/\(.*\)\.git .*:\1:")
PROJECT = wheelbarrow
ID = pikesley/${PROJECT}

all: build

build:
	docker build --no-cache -t ${ID} .

push:
	docker push ${ID}

run:
	docker-compose exec ${PROJECT} bash

test:
	docker-compose exec ${PROJECT} rspec

