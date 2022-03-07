#!/bin/bash

set -x

STATE=${1}
/usr/bin/docker exec --user www-data cloud_nextcloud_1 php occ maintenance:mode ${1}
