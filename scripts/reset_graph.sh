#!/usr/bin/env bash
# Reset stepping annotations to pre-stepping state.

#Original Annotations
NEGATIVE_TREND="http://purl.obolibrary.org/obo/psdo_0000100"
POSITIVE_TREND="http://purl.obolibrary.org/obo/psdo_0000099"
NEGATIVE_GAP="http://purl.obolibrary.org/obo/psdo_0000105"
POSITIVE_GAP="http://purl.obolibrary.org/obo/psdo_0000104"
ACHIEVEMENT="http://example.com/slowmo#Achievement"

O_ANNOS=("${NEGATIVE_TREND}" "${POSITIVE_TREND}"\
  "${NEGATIVE_GAP}" "${POSITIVE_GAP}")

#Stepping Annotations bases. _n gets appended
ST_NEGATIVE_TREND="http://example.com/slowmo#negative_trend"
ST_POSITIVE_TREND="http://example.com/slowmo#positive_trend"
ST_NEGATIVE_GAP="http://example.com/slowmo#negative_gap"
ST_POSITIVE_GAP="http://example.com/slowmo#positive_gap"
ST_ACHIEVEMENT="http://example.com/slowmo#achievement"

ST_ANNOS=("${ST_NEGATIVE_TREND}" "${ST_POSITIVE_TREND}"\
  "${ST_NEGATIVE_GAP}" "${ST_POSITIVE_GAP}" "${ST_ACHIEVEMENT}")

# Swap type $1 for type $2
# use prefixes like obo:psdo_00000XX and slowmo:Whatever 
swp_type(){
  FROM_TYPE=$1
  TO_TYPE=$2

read -r -d '' SWPTYPE <<SWPTYPE
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX slowmo: <http://example.com/slowmo#>

WITH <http://localhost:3030/ds/spek>
DELETE { ?s a <${FROM_TYPE}> }
INSERT { ?s a <${TO_TYPE}> } 
WHERE { 
  ?s a <${FROM_TYPE}> .
}
SWPTYPE

curl -silent -X POST --data-binary "${SWPTYPE}" \
  --header 'Content-type: application/sparql-update' \
  'http://localhost:3030/ds/update' 1> /dev/null 2>&1
} # End of swt_type function

# Set all predicate_0 back to original 
ARRAY_LEN=${#O_ANNOS[@]}

for (( i=0; i<${ARRAY_LEN}; i++ )); do
  OLD_PRED="${ST_ANNOS[${i}]}_0"
  NEW_PRED="${O_ANNOS[${i}]}"

  swp_type "${OLD_PRED}" "${NEW_PRED}" 
done



