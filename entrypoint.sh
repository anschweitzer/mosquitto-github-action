#!/bin/sh

VERSION=$1
PORTS=$2
CERTIFICATES=$3
CONFIG=$4
PASSWORD_FILE=$5
DATA=$6
LOG=$7
CONTAINERNAME=$8

echo "Certificates: $CERTIFICATES"
echo "Config: $CONFIG"

docker_run="docker run --detach --name $CONTAINERNAME"

for i in $(echo $PORTS | tr " " "\n")
do
  docker_run="$docker_run --publish $i"
done

if [ -n "$CERTIFICATES" ]; then
  docker_run="$docker_run --volume $CERTIFICATES:/mosquitto-certs:ro"
fi

if [ -n "$CONFIG" ]; then
  docker_run="$docker_run --volume $CONFIG:/mosquitto/config/mosquitto.conf:ro"
fi

if [ -n "$PASSWORD_FILE" ]; then
  docker_run="$docker_run --volume $PASSWORD_FILE:/mosquitto/config/mosquitto.passwd:ro"
fi

if [ -n "$DATA" ]; then
  docker_run="$docker_run --volume $DATA:/mosquitto/data:Z"
fi

if [ -n "$LOG" ]; then
  docker_run="$docker_run --volume $LOG:/mosquitto/log:Z"
fi

docker_run="$docker_run eclipse-mosquitto:$VERSION"

echo "$docker_run"
sh -c "$docker_run"
