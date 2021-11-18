#! /bin/bash

readonly SCRIPT_DIR=$(
    cd $(dirname $0)
    pwd
)

readonly MAKE_HOSTS_SCRIPT="${SCRIPT_DIR}/make_hosts.sh"

sh ${MAKE_HOSTS_SCRIPT} && ansible-playbook main.yml
