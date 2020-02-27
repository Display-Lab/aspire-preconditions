#!/usr/bin/env bash

# Run first part of pipeline up through generating candidates
# USE:
#  generate_candidates ${SPEK_PATH} ${ANNO_PATH} ${DATA_PATH}
# args: 
#  SPEK_PATH, ANNO_PATH, DATA_PATH
generate_candidates () {
 if [[ ! -e ${1} ]]; then
   echo "Spek file not found: ${1}"
   exit 1
 fi
 if [[ ! -e ${2} ]]; then
   echo "Annotations file not found: ${1}"
   exit 1
 fi
 if [[ ! -e ${3} ]]; then
   echo "Data file not found: ${3}"
   exit 1
 fi
 
 # Run bitstomach
 bitstomach.sh -s ${1} -a ${2} -d ${3} > /tmp/bs.json
 
 # Run candidate smasher
 cansmash generate --path /tmp/bs.json > /tmp/cs.json
}
