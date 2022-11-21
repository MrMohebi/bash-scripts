#!/bin/bash

usage() {
  __usage="
  Usage: $(basename $0) [OPTIONS]

  Options:
    -p, executable path <string>    [required] Absolute path to executable file
    -i, icon path       <string>    [required] Absolute path ti icon file
    -c, command         <string>    [required] Command shortcut name for executable file
    -h, help                                   help
  "
  echo "$__usage"
  exit 1;
}

while getopts h:c:i:p: flag; do
    case "${flag}" in
        i) icon=${OPTARG};;
        c) command=${OPTARG};;
        p) path=${OPTARG};;
        h) usage;;
        *) usage
    esac
done
if [ "$command" == '' ] || [ "$path" == '' ] || [ "$icon" == '' ]; then
    usage;
    exit 0;
fi


sudo ln -s "$path" /usr/bin/"$command" || echo "link exist"

sudo tee /usr/share/applications/"$command".desktop > /dev/null <<EOT
[Desktop Entry]
Version=1.0
Name=$command
Comment=$command
Exec=$command
Icon=$icon
Terminal=false
Type=Application
Categories=Utility;Development;
EOT
