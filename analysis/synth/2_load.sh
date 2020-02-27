#!/usr/bin/env bash

##################
## Define Paths ##
##################

WS_DIR=/home/grosscol/workspace
CP_DIR=${WS_DIR}/kb/causal_pathways
CP_JSON=/tmp/causal_paths.json

BASE_DIR=/home/grosscol/workspace/aspire/preconds
CS_SPEK=${BASE_DIR}/cansmash_out/synth_cs.json


##################
## Start Fuskei ##
##################
ping_fuseki(){ curl -s -o /dev/null -w "%{http_code}" localhost:3030/$/ping; }

if [[ $(ping_fuseki) -ne 200 ]]; then
  echo >&2 "Fuseki not running locally. Attempting to start it."; 

  # Try to start custom fuseki locally
  export JVM_ARGS="-Xmx8g"
  fuseki-server --mem --update /ds 1> fuseki.out 2>&1 &

  # Wait for it to start.
  COUNTER=0
  MAX_PINGS=4
  until [[ $(ping_fuseki) -eq 200 || ${COUNTER} -eq ${MAX_PINGS} ]]; do
    read -p "Waiting five secs for Fuseki to start..." -t 5
    echo ""
    let COUNTER=${COUNTER}+1
  done
fi

##################
## Clean Fuskei ##
##################

echo "Dropping existing graphs"
s-delete "http://localhost:3030/ds" "seeps"
s-delete "http://localhost:3030/ds" "spek"

#######################
## Load Causal Paths ##
#######################

# Add each causal pathway to fuseki
echo "Loading causal pathways into local fuseki"
RES=$(ls $CP_DIR | wc -l)
echo "count of causal pathway files in directory: ${RES}"

# Consolidating causal pathways into a single file if not done already.
if [[ ! -e ${CP_JSON} ]]; then
  jq -s '{ "@context": ([ .[]."@context" ] | unique | .[0]), "@graph":[ .[]."@graph"[] ]}' \
    ${CP_DIR}/*.json > ${CP_JSON}
fi

curl --silent -X PUT --data-binary @${CP_JSON} \
  --header 'Content-type: application/ld+json' \
  "http://localhost:3030/ds?graph=seeps" 2>/dev/null >&2 

# Count Causal Pathways
read -r -d '' CPQUERY <<'CPQUERY'
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX slowmo: <http://example.com/slowmo#>

SELECT (COUNT(?path) as ?count)
FROM <http://localhost:3030/ds/seeps>
WHERE {
  ?path a obo:cpo_0000029 .
}
CPQUERY

JQ_FMT_CAND='(.results.bindings[0] | map(.value))[0]'
RES=$(s-query --server "http://localhost:3030/ds" "${CPQUERY}" | jq "${JQ_FMT_CAND}")
echo "count of causal pathways in seeps graph: ${RES}"

###############
## Load Spek ##
###############
echo "Loading spek into local fuseki"

HAS_CANDI_URI="http://example.com/slowmo#HasCandidate"
echo "count of candidates from json"
jq --arg hascandi "${HAS_CANDI_URI}" '.[$hascandi] | length' ${CS_SPEK}

curl --silent -X PUT --data-binary @${CS_SPEK} \
  --header 'Content-type: application/ld+json' \
  "http://localhost:3030/ds?graph=spek" 2>/dev/null >&2 

