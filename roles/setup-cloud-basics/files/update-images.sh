#!/bin/bash

LOGFILE="/var/log/update-images.log"

echo "$(date) pulling images..." 2>&1 >> ${LOGFILE}
# pull new versions of all images
docker images |grep -v REPOSITORY|awk '{print $1":"$2}'| grep -v "<none>" | xargs -L1 docker pull 2>&1 >> ${LOGFILE}

echo "$(date) pulling images done!" 2>&1 >> ${LOGFILE}

echo "$(date) updating compose deployments!" 2>&1 >> ${LOGFILE}
# if this is done, we reload the deployments
for compose in $(ls /root/docker-compose/) ; do
  echo "$(date) deploying ${compose}..." 2>&1 >> ${LOGFILE}
  docker-compose --project-name cloud -f /root/docker-compose/${compose}/docker-compose.yaml up -d 2>&1 >> ${LOGFILE}
done
echo "$(date) compose deployments updated!" 2>&1 >> ${LOGFILE}
echo "" 2>&1 >> ${LOGFILE}
