#!/bin/bash

state=$1
node=$2


usage() {
  __usage="
  Usage: $(basename $0) [OPTIONS]

  Options:
    \$1, state name <string>      [required] state name(dev, prod ,etc)
    \$2, node name  <string>      [required] node name(node1, node2 ,etc)
  "
  echo "$__usage"
  exit 1;
}

if [ "$state" == '' ] || [ "$node" == '' ]; then
  usage;
  exit 0;
fi

containerName=$(docker ps --format "{{.Names}}" | grep "$state" | grep "$node")

docker exec -it "$containerName" bash -c 'mysqlsh -uroot -p"$MYSQL_ROOT_PASSWORD" --js -e "dba.rebootClusterFromCompleteOutage()"'









