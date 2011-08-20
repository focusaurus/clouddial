#!/bin/sh

PREFIX=rgtest
REGION="us-west-1"

function err() {
    echo "${@}" 1>&2
}

function checkPrereqs() {
    #TODO environment sanity checks
    #knife command
    #SSH agent
    #knife.rb configured
    #etc

    #This is just an example
    #Many more checks would be helpful for the end luser
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
          --region "${REGION}"
        INDEX=$((${INDEX} + 1))
    done
}

#This function isn't used any more. The Chef recipe handles this
#function postScript() {
#    knife ssh 'name:rgtest-*' 'sleep 10 && uptime | tee /tmp/uptime.out'  \
#      --identity-file  ~/.ssh/knife.pem \
#      --attribute cloud.public_hostname \
#      --ssh-user ubuntu
#}

function deleteNode() {
    knife node delete "${1}" --yes
}

function deleteEC2() {
    knife ec2 server delete "${1}" --region "${REGION}"
}
checkPrereqs || exit $?
createInstances ${1-1}
