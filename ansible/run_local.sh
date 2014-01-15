#!/bin/sh
BASE_DIR=$(cd $(dirname $0);  pwd -P)
ansible-playbook $BASE_DIR/helloworld_local.yaml -i $BASE_DIR/inventoryfile

