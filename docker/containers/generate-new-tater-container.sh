#!/bin/bash

#Argument parsing
if [[ $# > 1 ]]
then
  key="$1"
fi

case $key in
  -n|--name)
    NAME="$2"
    ;;
  *)
    echo "Please specify container name, e.g.: --name eha"
    echo ""
    exit 1;
    ;;
esac

# Lowercase the $NAME
NAME="$(tr [A-Z] [a-z] <<< "$NAME")"

# Create the sub-directory
mkdir -p tater

if [[ -n "$NAME" ]]; then
  echo "${NAME}.tater.io:
container_name: ${NAME}.tater.io
image: docker-repository.tater.io:5000/apps/tater
ports:
  - \"8002:3000\"
restart: always
environment:
  - MONGO_URL=mongodb://10.0.0.92:27017/${NAME}
  - ROOT_URL=https://${NAME}.tater.io
  - PORT=3000
" >> "tater/${NAME}"
fi