#!/bin/bash
set -x
if [ -z "$1" ]; then
    echo "Error: No architecture specified."
    echo "Usage: $0 <x86|arm>"
    exit 1
fi

ARCH=$1
# Validate the architecture argument
if [[ "$ARCH" != "x86" && "$ARCH" != "arm" ]]; then
    echo "Error: Invalid architecture specified: $ARCH"
    echo "Valid options are: x86, arm"
    exit 1
fi

# Set the correct image based on architecture argument
DISTRO=ubuntu
if [ "$ARCH" == "arm" ]; then
    IMAGE="arm64v8/$DISTRO"
else
    IMAGE="$DISTRO"
fi



CNAME=cppfv
docker stop $CNAME
docker rm $CNAME
set -e
docker pull $IMAGE
# ssh port is forwarded to 8372 of host in case we want to run emacs gui over ssh -Y. but this script does not install sshd in the container
docker run --name $CNAME -d -ti -w /root -p 8372:22 $IMAGE bash -l
docker exec $CNAME mkdir /root/fv-workspace
docker cp -a . $CNAME:/root/fv-workspace/
docker exec $CNAME bash -c "cd /root/fv-workspace && ./setupDebian.sh"
