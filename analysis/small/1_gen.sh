#!/usr/bin/env bash
BASE_DIR=/home/grosscol/workspace/aspire/preconds

# Inputs
SPEK_PATH=${BASE_DIR}/analysis/small/sm_spek.json
DATA_PATH=${BASE_DIR}/data/mpog_sm_data.csv
ANNO_PATH=/home/grosscol/workspace/spekex/inst/extdata/aspire-annotations.r

# Outputs
BS_SPEK=${BASE_DIR}/bitstomach_out/small_bs.json
CS_SPEK=${BASE_DIR}/cansmash_out/small_cs.json

# Run bitstomach
bitstomach.sh -s ${SPEK_PATH} -a ${ANNO_PATH} -d ${DATA_PATH} | jq . > ${BS_SPEK}

# Run candidate smasher
#cansmash generate --path ${BS_SPEK} | jq . > ${CS_SPEK}
