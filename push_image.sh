set -e

image_name="spark-on-k8s"
image_version=2.4.4-2.12
image_name=$image_name:$image_version

docker tag $image_name $HW_IMAGE_PREFIX/$image_name
docker push $HW_IMAGE_PREFIX/$image_name
