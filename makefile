.SILENT:

# Setup —————————————————————————————————————————————————————————————————————————
DOCKER_DIR      = ./docker
DOCKER_NAME     = docker_php_1
DOCKER_APP_DIR  = /app/
DOCKER          = docker
DOCKER-COMPOSE  = cd $(DOCKER_DIR) && docker-compose
DOCKER-EXEC      = docker exec --tty=true -w $(DOCKER_APP_DIR) -i $(DOCKER_NAME)
SYMFONY         = $(DOCKER-EXEC) bin/console
SYMFONY-CLI     = ./symfony
COMPOSER        = $(DOCKER-EXEC) composer

PARAM = $(filter-out $@,$(MAKECMDGOALS))

.DEFAULT_GOAL := help

## —— The MAT API Make file  ——————————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

##
## Docker
## -----------------
##
docker-enter: ## Enter in PHP web including Symfony Docker with API Platform
	$(DOCKER-EXEC) /bin/bash

docker-up: ## Docker up and build
	$(DOCKER-COMPOSE) up --detach --build --force-recreate

docker-down: ## Docker down
	$(DOCKER-COMPOSE) down --remove-orphans 

docker-down-all: ## Docker down all docker containers
	docker stop `docker ps -a -q`


##
## Composer
## -----------------
##
composer: ## Run compose
	$(COMPOSER) $(PARAM)

composer-install: composer.lock ## Install vendors according to the current composer.lock file
composer-install: composer.lock ## Install vendors according to the current composer.lock file
	$(COMPOSER) install $(PARAM)

composer-update: composer.json ## Update vendors according to the current composer.json file
	$(COMPOSER) update $(PARAM)

##
## Symfony
## -----------------
##
sf: ## List all Symfony commands (use param to exec, ex : 'c:c --env=prod')
	$(SYMFONY) $(PARAM)

cc: ## Clear the cache
	$(SYMFONY) c:c $(PARAM)

sf-warmup: ## Warmump the cache
	$(SYMFONY) cache:warmup $(PARAM)
