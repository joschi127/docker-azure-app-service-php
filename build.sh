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
DOCKER_ALREADY_LOGGED_IN_USERNAME="$(docker info | grep 'Username:' | sed 's/Username: //')"
if [ "$DOCKER_ALREADY_LOGGED_IN_USERNAME" = "" ] || [ "$DOCKER_ALREADY_LOGGED_IN_USERNAME" != "$DOCKER_USERNAME" ]
then
    docker login -u "$DOCKER_USERNAME"
fi

# generate build number
buildnumber=$(date -u +"%Y%m%d_%H%M")

# build base images
#docker build $NO_CACHE_PARAM -q -t joschi127/azure-app-service-php:5.6.36-apache_"$buildnumber" 5.6.36-apache
#docker build $NO_CACHE_PARAM -q -t joschi127/azure-app-service-php:7.0.30-apache_"$buildnumber" 7.0.30-apache
#docker build $NO_CACHE_PARAM -q -t joschi127/azure-app-service-php:7.2.5-apache_"$buildnumber" -t joschi127/azure-app-service-php:latest_"$buildnumber" 7.2.5-apache
docker build $NO_CACHE_PARAM -q -t joschi127/azure-app-service-php:7.2-apache_"$buildnumber" -t joschi127/azure-app-service-php:latest_"$buildnumber" 7.2-apache
docker tag joschi127/azure-app-service-php:latest_"$buildnumber" joschi127/azure-app-service-php:7.2-apache_latest
docker tag joschi127/azure-app-service-php:latest_"$buildnumber" joschi127/azure-app-service-php:latest

#docker push joschi127/azure-app-service-php:5.6.36-apache_"$buildnumber"
#docker push joschi127/azure-app-service-php:7.0.30-apache_"$buildnumber"
#docker push joschi127/azure-app-service-php:7.2.5-apache_"$buildnumber"
docker push joschi127/azure-app-service-php:7.2-apache_"$buildnumber"
docker push joschi127/azure-app-service-php:7.2-apache_latest
docker push joschi127/azure-app-service-php:latest_"$buildnumber"
docker push joschi127/azure-app-service-php:latest

# xdebug depends on base images
# generate dockerfile for xdebug
#sed -e s/reponame/joschi127/g -e s/buildnumber/"$buildnumber"/g 5.6.36-apache-xdebug/Dockerfile.template > 5.6.36-apache-xdebug/Dockerfile
#sed -e s/reponame/joschi127/g -e s/buildnumber/"$buildnumber"/g 7.0.30-apache-xdebug/Dockerfile.template > 7.0.30-apache-xdebug/Dockerfile
#sed -e s/reponame/joschi127/g -e s/buildnumber/"$buildnumber"/g 7.2.5-apache-xdebug/Dockerfile.template > 7.2.5-apache-xdebug/Dockerfile

# build xdebug images
#docker build $NO_CACHE_PARAM -q -t joschi127/azure-app-service-php:5.6.36-apache-xdebug_"$buildnumber" 5.6.36-apache-xdebug
#docker build $NO_CACHE_PARAM -q -t joschi127/azure-app-service-php:7.0.30-apache-xdebug_"$buildnumber" 7.0.30-apache-xdebug
#docker build $NO_CACHE_PARAM -q -t joschi127/azure-app-service-php:7.2.5-apache-xdebug_"$buildnumber" -t joschi127/azure-app-service-php:latest-xdebug_"$buildnumber" 7.2.5-apache-xdebug

#docker push joschi127/azure-app-service-php:5.6.36-apache-xdebug_"$buildnumber"
#docker push joschi127/azure-app-service-php:7.0.30-apache-xdebug_"$buildnumber"
#docker push joschi127/azure-app-service-php:7.2.5-apache-xdebug_"$buildnumber"
#docker push joschi127/azure-app-service-php:latest-xdebug_"$buildnumber"

# remove old local images, if they are not used
for old_image_id in $(docker images | grep joschi127/azure-app-service-php | grep -v _latest | grep -v _$buildnumber | awk '{print $3}')
do
    docker rmi $old_image_id || echo "Keeping image $old_image_id, seems to be still in use"
done

# final success message
echo "Successfully completed"
