PORT := 8080
REGISTRY_ENDPOINT := rg.fr-par.scw.cloud
REGISTRY_NAMESPACE := serveless
IMAGE_NAME := decidim-captcha-api
VERSION := latest
TAG := $(REGISTRY_ENDPOINT)/$(REGISTRY_NAMESPACE)/$(IMAGE_NAME):$(VERSION)

local-run:
	PORT=$(PORT) crystal run src/app.cr

local-build:
	crystal build -p src/app.cr -o dist/app

build:
	docker build . --tag $(TAG)
