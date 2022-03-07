#!/bin/bash

# Deploying either cloud or raspi or both

export ANSIBLE_HOST_KEY_CHECKING=False

if [ "$1" = "cloud" ] ; then
  if [ "$2" = "justdeploy" ] ; then
    ansible-playbook $3 $4 -i inventory-cloud.yaml --tags containers basic-install-cloud.yaml  --vault-password-file ./vault.password
  else
    ansible-playbook $2 $3 -i inventory-cloud.yaml  basic-install-cloud.yaml --vault-password-file ./vault.password
  fi
elif [ "$1" = "raspi" ] ; then
  if [ "$2" = "justdeploy" ] ; then
    ansible-playbook $3 $4 -i inventory-raspi.yaml --tags containers basic-install-raspi.yaml --vault-password-file ./vault.password
  else
    ansible-playbook $2 $3 -i inventory-raspi.yaml  basic-install-raspi.yaml --vault-password-file ./vault.password
  fi
elif [ "$1" = "test" ] ; then
  if ! ping -t 5 -c1 192.168.178.201 2>&1 >/dev/null; then
    echo "No test VM running, starting in 5 Seconds..."
    sleep 5
    pushd ../vagrant/
    ./vup.sh
    popd
    echo "VM started, starting ansible test deployment in 5 Seconds"
    sleep 5
  fi
  ansible-playbook $2 $3 -i inventory-test.yaml  basic-install-cloud.yaml --vault-password-file ./vault.password
else
  ansible-playbook $1 $2 -i inventory-cloud.yaml  basic-install-cloud.yaml --vault-password-file ./vault.password
  ansible-playbook $1 $2 -i inventory-raspi.yaml  basic-install-raspi.yaml --vault-password-file ./vault.password
fi
