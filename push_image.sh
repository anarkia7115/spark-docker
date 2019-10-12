set -e

image_name="spark-on-k8s"
image_version=2.4.4
image_name=$image_name:$image_version

docker build \
    --build-arg HW_BUCKET \
    --build-arg FILE_CHANGE=true \
    --build-arg AK \
    --build-arg SK \
    -t $image_name .

#docker tag $image_name $HW_IMAGE_PREFIX/$image_name
#docker push $HW_IMAGE_PREFIX/$image_name
