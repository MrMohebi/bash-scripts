#!/bin/bash

FOLDER_NAME="converted"

mkdir -p "$FOLDER_NAME"

for entry in ./*.png
do
  convert -geometry 640x -gravity NorthEast -background "rgba(255,255,255,0)" -extent 1920x1080 "$entry" -set filename:t "./$FOLDER_NAME/%t-forIde" '%[filename:t].png'
done

