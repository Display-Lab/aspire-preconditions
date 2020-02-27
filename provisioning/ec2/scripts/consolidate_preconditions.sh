#!/usr/bin/env bash

# Consolidate causal pathways into single file. 

CP_DIR=/home/ec2-user/kb/causal_pathways
CP_JSON=/home/ec2-user/causal_paths.json

# Consolidating causal pathways into a single file if not done already.
if [[ ! -e ${CP_JSON} ]]; then
  jq -s '{ "@context": ([ .[]."@context" ] | unique | .[0]), "@graph":[ .[]."@graph"[] ]}' \
    ${CP_DIR}/*.json > ${CP_JSON}
fi
