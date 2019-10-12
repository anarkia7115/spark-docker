set -e

image_name="spark-on-k8s"
image_version=2.4.4-2.12
image_name=$image_name:$image_version
cp /usr/local/bin/obsutil .

docker build \
    --build-arg HW_BUCKET \
    --build-arg FILE_CHANGE=true \
    --build-arg AK \
    --build-arg SK \
    -t $image_name .

rm ./obsutil
