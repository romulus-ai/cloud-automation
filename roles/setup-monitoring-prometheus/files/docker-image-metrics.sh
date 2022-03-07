#!/bin/bash


for image in $(docker images | awk '{print $1":"$2";"$3}' | grep -v REPOSITORY) ; do

  image_id_short=$(echo $image | cut -d';' -f2)
  image=$(echo $image | cut -d';' -f1)

  date_time_created=$(docker inspect -f '{{ .Created }}' ${image})
  timestamp_created=$(date --date="${date_time_created}" +"%s")

  date_time_pulled=$(stat -c %y /var/lib/docker/image/overlay2/imagedb/content/sha256/${image_id_short}*)
  timestamp_pulled=$(date --date="${date_time_pulled}" +"%s")

  user="library"
  image_name=""
  image_tag="latest"
  if [[ $image == *"/"* ]]; then
    user="$(echo $image | cut -d'/' -f1)"
    image_name="$(echo $image | cut -d'/' -f2 | cut -d ':' -f1)"
    image_tag="$(echo $image | cut -d'/' -f2 | cut -d ':' -f2)"
  else
    image_name="$(echo $image | cut -d ':' -f1)"
    image_tag="$(echo $image | cut -d ':' -f2)"
  fi

  echo "docker_image_created{image=\"${image_name}\", user=\"${user}\", tag=\"${image_tag}\"} ${timestamp_created}"
  echo "docker_image_pulled{image=\"${image_name}\", user=\"${user}\", tag=\"${image_tag}\"} ${timestamp_pulled}"
done
