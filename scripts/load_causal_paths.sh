#!/usr/bin/env bash
CP_JSON=/tmp/cp.json

# Dependencies (Fuseki) path
FUSEKI_DIR=/opt/fuseki/apache-jena-fuseki-3.10.0
ping_fuseki(){ curl -s -o /dev/null -w "%{http_code}" localhost:3030/$/ping; }

if [[ $(ping_fuseki) -ne 200 ]]; then
  echo >&2 "Fuseki not running locally. Attempting to start it."; 

  # Try to start custom fuseki locally
  export JVM_ARGS="-Xmx8g -Xms2g"
  ${FUSEKI_DIR}/fuseki-server --mem --update /ds 1> fuseki.out 2>&1 &

  # Wait for it to start.
  COUNTER=0
  MAX_PINGS=4
  until [[ $(ping_fuseki) -eq 200 || ${COUNTER} -eq ${MAX_PINGS} ]]; do
    read -p "Waiting five secs for Fuseki to start..." -t 5
    echo ""
    let COUNTER=${COUNTER}+1
  done
fi

# Load in causal pathways
curl --silent -X PUT --data-binary @${CP_JSON} \
  --header 'Content-type: application/ld+json' \
  'http://localhost:3030/ds?graph=seeps' >&2
