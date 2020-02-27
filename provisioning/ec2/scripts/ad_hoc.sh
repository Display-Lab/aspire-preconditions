#!/usr/bin/env bash

# Querries spek graph and produces summary csv
#   Expects s-query to be on PATH

read -r -d '' HEADER <<'HEADER'
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX slowmo: <http://example.com/slowmo#>
HEADER

# Write your own ad hoc queries here

read -r -d '' QUERY <<'QUERY'
SELECT (COUNT(?candi) as ?count)
FROM <http://localhost:3030/ds/spek>
WHERE {
  ?candi a obo:cpo_0000053 .
}
QUERY

CONTENT="${HEADER}"$'\n'"${QUERY}"
s-query --server "http://localhost:3030/ds" "${CONTENT}"
