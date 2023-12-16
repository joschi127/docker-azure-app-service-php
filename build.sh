#!/usr/bin/env bash
set -x -e

# parse arguments
if [ "$1" = "" ] || ([ "$2" != "" ] && [ "$2" != "--no-cache" ])
then
    echo "Usage: $0 DOCKER_USERNAME [ --no-cache ]"
    exit 1
fi
DOCKER_USERNAME="$1"
NO_CACHE_PARAM="$2"

# login
DOCKER_ALREADY_LOGGED_IN_USERNAME="$(docker info | grep 'Username:' | sed 's/Username://' | awk '{$1=$1;print}')"
if [ "$DOCKER_ALREADY_LOGGED_IN_USERNAME" = "" ] || [ "$DOCKER_ALREADY_LOGGED_IN_USERNAME" != "$DOCKER_USERNAME" ]
then
    docker login -u "$DOCKER_USERNAME"
fi

# generate build number
buildnumber=$(date -u +"%Y%m%d_%H%M")

# build images
#docker build $NO_CACHE_PARAM -q \
#    -t joschi127/azure-app-service-php:7.2-apache_"$buildnumber" \
#    -t joschi127/azure-app-service-php:7.2-apache_latest \
#    7.2-apache
#
#docker build $NO_CACHE_PARAM -q \
#    -t joschi127/azure-app-service-php:7.3-apache_"$buildnumber" \
#    -t joschi127/azure-app-service-php:7.3-apache_latest \
#    7.3-apache
#
#docker build $NO_CACHE_PARAM -q \
#    -t joschi127/azure-app-service-php:7.4-apache_"$buildnumber" \
#    -t joschi127/azure-app-service-php:7.4-apache_latest \
#    7.4-apache

docker pull php:8.1-apache
docker build $NO_CACHE_PARAM -q \
    -t joschi127/azure-app-service-php:8.1-apache_"$buildnumber" \
    -t joschi127/azure-app-service-php:8.1-apache_latest \
    8.1-apache

docker pull php:8.2-apache
docker build $NO_CACHE_PARAM -q \
    -t joschi127/azure-app-service-php:8.2-apache_"$buildnumber" \
    -t joschi127/azure-app-service-php:8.2-apache_latest \
    -t joschi127/azure-app-service-php:latest_"$buildnumber" \
    -t joschi127/azure-app-service-php:latest \
    8.2-apache

# push images
#docker push joschi127/azure-app-service-php:7.2-apache_"$buildnumber"
#docker push joschi127/azure-app-service-php:7.2-apache_latest
#docker push joschi127/azure-app-service-php:7.3-apache_"$buildnumber"
#docker push joschi127/azure-app-service-php:7.3-apache_latest
#docker push joschi127/azure-app-service-php:7.4-apache_"$buildnumber"
#docker push joschi127/azure-app-service-php:7.4-apache_latest
docker push joschi127/azure-app-service-php:8.1-apache_"$buildnumber"
docker push joschi127/azure-app-service-php:8.1-apache_latest
docker push joschi127/azure-app-service-php:8.2-apache_"$buildnumber"
docker push joschi127/azure-app-service-php:8.2-apache_latest
docker push joschi127/azure-app-service-php:latest_"$buildnumber"
docker push joschi127/azure-app-service-php:latest

# remove old local images, if they are not used
for old_image_id in $(docker images | grep joschi127/azure-app-service-php | grep -v _latest | grep -v _$buildnumber | awk '{print $3}')
do
    docker rmi $old_image_id || echo "Keeping image $old_image_id, seems to be still in use"
done

# final success message
echo "Successfully completed"
