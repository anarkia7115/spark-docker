set -e

image_name="gcc"
image_version="latest"
image_name=$image_name:$image_version
push_image_name=`basename $image_name`

#docker pull $image_name

docker tag $image_name $HW_IMAGE_PREFIX/$push_image_name
docker push $HW_IMAGE_PREFIX/$push_image_name
