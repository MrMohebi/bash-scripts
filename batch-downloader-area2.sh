#!/bin/bash

usage() {
  __usage="
  Usage: $(basename $0) [OPTIONS]

  Options:
    \$1, start number <number>    [required] starting number(can be multiple digits like: 01)
    \$2, end number <number>      [required] ending number(can be multiple digits like: 09)
    \$3, link <string>            [required] link witch has star to replace with numbers (https://site.com/somefile_part*.zip)
    \$4, app-command <string>     [optional] command that starts launches the client app(motrix)
    -h, help                                 help

  "
  echo "$__usage"
  exit 1;
}

start=$1
end=$2
link=$3
cmd='motrix'
stars="${link//[^*]}"
length="${#stars}"

if [ "$4" != '' ]; then
  cmd=$4
fi

while getopts h: flag; do
  case "${flag}" in
    h) usage;;
    *) usage
  esac
done

if [ "$start" == '' ] || [ "$end" == '' ] || [ "$link" == '' ]; then
  usage;
  exit 0;
fi

if [ "$length" == 0 ]; then
  echo "link doesn't contain star(*)!"
  echo "$link"
  exit 0;
fi

if pgrep -x "$cmd" > /dev/null; then
    echo "$cmd is Running"
  else
    if [ "$cmd" != '' ]; then
      $cmd &
      sleep 2
      echo "$cmd started"
    fi
fi

for c in $(eval "echo {$start..$end}");do
  curl 'http://localhost:16800/jsonrpc' --data-raw "[{\"jsonrpc\":\"2.0\",\"method\":\"aria2.addUri\",\"id\":1,\"params\":[[\"${link//[*]/$c}\"],{}]}]"
  echo "${link//[*]/$c}"
done
