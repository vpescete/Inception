COMPOSE_FILE	=	./srcs/docker-compose.yml

all:
	docker-compose -f $(COMPOSE_FILE) up -d

stop:
	docker-compose -f $(COMPOSE_FILE) down