#! /bin/bash

readonly SCRIPT_DIR=$(
    cd $(dirname $0)
    pwd
)

readonly HOST_PATH="${SCRIPT_DIR}/roles/sys/defaults/main.yml "
readonly FILE_PATH="${SCRIPT_DIR}/hosts"

function get_host() {
    awk -F':' '{print $2}' ${HOST_PATH} | head -n 3 - | awk 'NF' | sed 's/\"//g' | sed 's/ //'
}

function search_host() {
    local search_result=$(echo $1 | xargs host | grep -c "not found")

    if [ ${search_result} = 0 ]; then
        echo "Host found"
    elif [ ${search_result} = 1 ]; then
        echo "No host found"
    fi

}

function get_ip() {
    local host_ip=$(echo $1 | xargs host | awk '{print $4}')
    echo ${host_ip}
}

function make_hosts_file() {
    local host_name=$1
    local ip_address=$2
    local txt=[$host_name]"\n"$ip_address

    echo -e ${txt} >${FILE_PATH}

}

HOST_NAME=$(get_host)

SEARCH_RESULT=$(search_host ${HOST_NAME})

if [[ ${SEARCH_RESULT} =~ .*No.* ]]; then
    echo ${SEARCH_RESULT}
    cp /dev/null ${FILE_PATH}
    exit 1
else
    IP=$(get_ip ${HOST_NAME})
    make_hosts_file ${HOST_NAME} ${IP}
    echo "successfully created hosts file!!"
    echo "~~~~~~~~~~~~~~~~~~~~~"
    cat ${FILE_PATH}
    echo "FILE_PATH":"${FILE_PATH}"
    echo "~~~~~~~~~~~~~~~~~~~~~"
    exit 0
fi
