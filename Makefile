PORT := 8080
REGION := fr-par
REGISTRY_ENDPOINT := rg.$(REGION).scw.cloud
REGISTRY_NAMESPACE := decidim-captcha-api
IMAGE_NAME := decidim-captcha-api
VERSION := latest
TAG := $(REGISTRY_ENDPOINT)/$(REGISTRY_NAMESPACE)/$(IMAGE_NAME):$(VERSION)

local-run:
	PORT=$(PORT) crystal run src/app.cr

local-build:
	crystal build -p src/app.cr -o dist/app
	cp -r src/locales dist/locales

build:
	docker build . --compress --tag $(TAG)

run:
	docker run -it -e PORT=$(PORT) -p $(PORT):$(PORT) --rm $(TAG)

push:
	docker push $(TAG)

deploy:
	@make build
	@make push

login:
	docker login $(REGISTRY_ENDPOINT) -u userdoesnotmatter -p $(TOKEN)

make test:
	curl localhost:$(PORT)
