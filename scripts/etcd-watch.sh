#!/bin/bash

declare -r ETCD_HOST=${ETCD_HOST:-"172.17.42.1"}
declare -r ETCD_URL=http://${ETCD_HOST}:4001/v2/keys/instances/${INSTANCE_ID}/running

declare -r LOG_DIR=/var/log/cassandra
declare -r TTL=30
declare -r TTL_LIMIT=5
declare -r SUCCESS_SLEEP=20
declare -r FAILURE_SLEEP=1

declare RET_VAL
declare REMAINING_TTL
declare CHECK_START
declare CHECK_END
declare PUT_START
declare PUT_END
declare SLEEP_START=0
declare SLEEP_END=0

while true; do
    # Check status
    CHECK_START=$(date +%s)
    CHECK_END=$(date +%s)

    mode=$(/opt/elassandra/bin/nodetool netstats | grep 'Mode')
    if [[ $mode == *"NORMAL"* ]]; then
        # Update running state in etcd
        PUT_START=$(date +%s)
        REMAINING_TTL=$(curl ${ETCD_URL} -s -XPUT -d value=true -d ttl=${TTL} | jq '.prevNode.ttl // -99')
        PUT_END=$(date +%s)
        if [ ${REMAINING_TTL} -le ${TTL_LIMIT} ] && [ ${SLEEP_START} -ne 0 ]; then
            echo "$(date +%F' '%H:%M:%S) TTL: ${REMAINING_TTL} LAST CHECK: $((${CHECK_END} - ${CHECK_START})) LAST PUT: $((${PUT_END} - ${PUT_START})) LAST SLEEP: $((${SLEEP_END} - ${SLEEP_START}))" >> ${LOG_DIR}/ttl.log
        fi

        # Sleep after success
        SLEEP_START=$(date +%s)
        sleep ${SUCCESS_SLEEP}
        SLEEP_END=$(date +%s)
    else
        # Sleep after failure
        SLEEP_START=$(date +%s)
        sleep r{FAILURE_SLEEP}
        SLEEP_END=$(date +%s)
    fi
done
