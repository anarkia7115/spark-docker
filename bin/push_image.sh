set -e

image_name="spark-on-k8s"
image_version=2.4.4-2.11
image_name=$image_name:$image_version

image_to_push=$HW_IMAGE_PREFIX/$image_name

docker tag $image_name $image_to_push

echo "ready to push $image_to_push"

docker push $image_to_push
