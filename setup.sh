#!/bin/bash

CONTAINER=auction-mongodb

if [ "x$(which docker)" == "x" ]; then
  echo "docker is missing" # "UNKNOWN - Missing docker binary"
  exit 1
fi

docker info > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "UNKNOWN - Unable to talk to the docker daemon"
  exit 1
fi

RUNNING=$(docker inspect --format="{{.State.Running}}" $CONTAINER 2> /dev/null)

if [ $? -eq 1 ]; then
  docker run --detach --name $CONTAINER -p 27017:27017 --env MONGODB_DATABASE=auction-db \
    --env MONGODB_USER=auction-user --env MONGODB_PASSWORD=password --env MONGODB_ROOT_PASSWORD=rootpassword mongo:latest
elif [ "$RUNNING" == "false" ]; then
  docker start $CONTAINER
fi
wait

RESTARTING=$(docker inspect --format="{{.State.Restarting}}" $CONTAINER)

if [ "$RESTARTING" == "true" ]; then
  echo "WARNING - $CONTAINER state is restarting."
  exit 1
fi

until [ "`docker inspect -f {{.State.Running}} $CONTAINER`"=="true" ]; do
    sleep 0.1;
done;

yarn prisma
wait

exit
