set -e
set +x
#git clone -b executeBlockProof git@github.com:category-labs/monad/
#IMAGE=arm64v8/debian
IMAGE=debian
docker pull $(IMAGE)
docker run --name fvarm -ti -w /root $(IMAGE) bash -l
docker stop fvarm
docker cp -a . fvarm:/root/
docker start fvarm
docker exec fvarm /root/fv-workspace/setupDebian.sh
