#!/bin/sh

PREFIX=rgtest

function err() {
    echo "${@}" 1>&2
}

function checkPrereqs() {
    #TODO environment sanity checks
    #knife command
    #SSH agent
    #etc

    #This is just an example
    EC=0
    which knife > /dev/null 2>&1 || EC=$?
    if [ ${EC} -ne 0 ]; then
        err "knife command not found."
        err "Make sure your chef environment is configured correctly."
        return 6
    fi
}

function createInstances() {
    TOTAL=$1
    INDEX=1

    AMI="ami-596f3c1c"
    while [ ${INDEX} -le ${TOTAL} ]
    do
        echo creating "${PREFIX}-${INDEX}"
        knife ec2 server create "clouddial" \
          --node-name "${PREFIX}-${INDEX}" \
          --image "${AMI}" \
          --flavor m1.small \
          --ssh-key knife \
          --identity-file ~/.ssh/knife.pem \
          --ssh-user ubuntu \
          --region us-west-1
        INDEX=$((${INDEX} + 1))
    done
}

function postScript() {
    knife ssh 'name:rgtest-*' 'sleep 10 && uptime | tee /tmp/uptime.out'  \
      --identity-file  ~/.ssh/knife.pem \
      --attribute cloud.public_hostname \
      --ssh-user ubuntu
}
checkPrereqs || exit $?
createInstances 2
postScript
