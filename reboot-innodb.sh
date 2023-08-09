#!/bin/bash

state=$1
node=$2

containerName=$(docker ps --format "{{.Names}}" | grep "$state" | grep "$node")

docker exec -it "$containerName" bash -c 'mysqlsh -uroot -p"$MYSQL_ROOT_PASSWORD" --js -e "dba.rebootClusterFromCompleteOutage()"'









