#!/usr/bin/env bash

docker compose up -d
sleep 3
docker exec prodmais ./container_services_start.sh
code .

