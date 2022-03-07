#!/bin/bash

export ANSIBLE_HOST_KEY_CHECKING=False

if [ -f $1 ] ; then
  ./convert-ssr-data.pl $1 | tee telefit-unified.csv

  ansible-playbook -i inventory-cloud.yaml import-ssrtrainings.yaml --vault-password-file ./vault.password

  rm -f *.csv
else
  echo "ERROR: $1 not found!"
  exit 1
fi