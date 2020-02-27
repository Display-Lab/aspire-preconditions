#!/usr/bin/env bash

# Main analysis
# all performers 
# all measures
# 2019 natioal data

# Source the generate preconditions function
. /home/grosscol/workspace/aspire/preconds/scripts/generate_candidates.sh

WS_DIR=/home/grosscol/workspace
PCON_DIR=${WS_DIR}/aspire/preconds

SPEK="${WS_DIR}/spekex/inst/extdata/aspire-spek.json"
ANNO="${WS_DIR}/spekex/inst/extdata/aspire-stepping-annotations.r"
DATA="${PCON_DIR}/data/mpog-unfd-2019.csv"

generate_candidates ${SPEK} ${ANNO} ${DATA}

jq . /tmp/bs.json > ${PCON_DIR}/bitstomach_out/main_bs.json
jq . /tmp/cs.json > ${PCON_DIR}/cansmash_out/main_cs.json
rm /tmp/bs.json
rm /tmp/cs.json

# Analysis requires larger memory footprint than is available on dev machines.
#  See provisioners for running main analysis.
