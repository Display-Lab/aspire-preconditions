#!/usr/bin/env bash

# Medium sized analysis.
# 10 performers
# 2 measures in the data
WS_DIR=/home/grosscol/workspace
BASE_DIR=${WS_DIR}/aspire/preconds

# Inputs
SPEK_PATH=${WS_DIR}/spekex/inst/extdata/aspire-spek.json
DATA_PATH=${BASE_DIR}/data/mpog-med.csv
ANNO_PATH=${WS_DIR}/spekex/inst/extdata/aspire-annotations.r

# Outputs
BS_SPEK=${BASE_DIR}/bitstomach_out/med_bs.json
CS_SPEK=${BASE_DIR}/cansmash_out/med_cs.json

# Run bitstomach
bitstomach.sh -s ${SPEK_PATH} -a ${ANNO_PATH} -d ${DATA_PATH} | jq . > ${BS_SPEK}

# Run candidate smasher
cansmash generate --path ${BS_SPEK} | jq . > ${CS_SPEK}
