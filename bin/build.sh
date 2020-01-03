set -e

image_name="spark-on-k8s"
image_version=2.4.4-2.11
image_name=$image_name:$image_version
cp `which obsutil` .

docker build \
    --build-arg HW_BUCKET \
    --build-arg FILE_CHANGE=true \
    --build-arg AK \
    --build-arg SK \
    -t $image_name .

rm ./obsutil
