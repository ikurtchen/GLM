#!/bin/bash

set -x

MODEL=model_blocklm_2B.sh
TASK=seq_cnndm_org.sh
PROFILE=OFF

SESSION_NAME="h_profiling_session"
OUTPUT_DIR=${SESSION_NAME}
DEVICE="--gaudi"
#DEVICE="--gaudi2"
PHASE="-phase=multi-enq"
#PHASE="--phase=device-acq"
GRAPH_LAUNCH="-g 1-20"
#GRAPH_LAUNCH=""
#BUFFER_SIZE="-b 256"
BUFFER_SIZE=""
TRACE_ANALYZER="--trace-analyzer on  --trace-analyzer-csv on"

if [ ${PROFILE} == "ON" ]; then
    # HW Events
    hl-prof-config ${DEVICE} -e off ${PHASE} ${GRAPH_LAUNCH} ${BUFFER_SIZE} -s ${SESSION_NAME} -o ${SESSION_NAME}

    # Per Enqueue mode and Multi Enqueue mode
    # hl-prof-config ${DEVICE} ${BUFFER_SIZE} ${TRACE_ANALYZER} --phase enq -e off --invoc csv --merged hltv -s ${SESSION_NAME} -o ${SESSION_NAME}
    # hl-prof-config ${DEVICE} ${BUFFER_SIZE} ${TRACE_ANALYZER} --phase multi-enq --invocations-range 1-100 -e off --merged hltv -s ${SESSION_NAME} -o ${SESSION_NAME}

    # API Only
    #hl-prof-config ${DEVICE} -e off --hw-trace off -s ${SESSION_NAME} -o ${SESSION_NAME}

    export HABANA_PROFILE=1
fi

bash scripts/ds_finetune_seq2seq.sh config_tasks/${MODEL} config_tasks/${TASK}
