#!/bin/sh

ID_FILE=~/.ssh/knife.pem
SSH_USER=ubuntu
PREFIX="${2-rgtest}"
REGION="us-west-1"
AMI="ami-596f3c1c"

DIR=$(dirname "${0}")

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
    local EC=0
    which knife > /dev/null 2>&1 || EC=$?
    if [ ${EC} -ne 0 ]; then
        err "knife command not found."
        err "Make sure your chef environment is configured correctly."
        return 6
    fi
}

function createInstance() {
    local NAME="${1}"
    echo creating "${NAME}"
    EC=0
    #"clouddial" is the chef run list (a recipe name)
    knife ec2 server create "clouddial" \
      --node-name "${NAME}" \
      --image "${AMI}" \
      --flavor m1.small \
      --ssh-key knife \
      --identity-file ~/.ssh/knife.pem \
      --ssh-user "${SSH_USER}" \
      --region "${REGION}" || EC=$?
    if [ $EC -ne 0 ]; then
      err "ec2 server create failed"
    fi
    return $EC
}

function gatherResult() {
    local NAME="${1}"
    echo "Gathering results from ${NAME}"
    #It would be nice if we could retrieve remote files with knife
    #But I couldn't easily find a way
    local HOSTNAME=$(knife node show "${NAME}" \
      --attribute cloud.public_hostname \
      --format text)
    mkdir "results/${HOSTNAME}"
    scp -r -i "${ID_FILE}" "${SSH_USER}@${HOSTNAME}:/tmp/rg_results/*" \
      "results/${HOSTNAME}"
}

function createInstances() {
    local TOTAL=$1
    local INDEX=1

    [ ! -d "${DIR}/results" ] && mkdir "${DIR}/results"
    while [ ${INDEX} -le ${TOTAL} ]
    do
        local NAME="${PREFIX}-${INDEX}"
        #We sleep 5 to allow Chef to register the new node.
        #Otherwise we get intermittent 404s
        (createInstance "${NAME}" && sleep 5 && gatherResult "${NAME}") &
        INDEX=$((${INDEX} + 1))
    done
    #Wait for parallel subshells to complete
    wait
}

function deleteNode() {
    knife node delete "${1}" --yes
}

function deleteEC2() {
    knife ec2 server delete "${1}" --region "${REGION}" --yes
}

function deleteInstance() {
    local NAME="${1}"
    ID=$(knife node show "${NAME}" --attribute ec2.instance_id \
      --format text)
    deleteEC2 "${ID}"
    deleteNode "${NAME}"
}
checkPrereqs || exit $?
createInstances ${1-1}
