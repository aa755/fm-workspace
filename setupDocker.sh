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
set +x
docker pull $IMAGE
docker run --name $CNAME -d -ti -w /root $IMAGE bash -l
docker exec $CNAME mkdir /root/fv-workspace
docker cp -a . $CNAME:/root/fv-workspace/
docker exec $CNAME bash -c "cd /root/fv-workspace && ./setupDebian.sh"
