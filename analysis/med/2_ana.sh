#!/usr/bin/env bash

# Medium sized analysis.
# 10 performers
# 2 measures in the data

WS_DIR=/home/grosscol/workspace
PCON_DIR=${WS_DIR}/aspire/preconds

HAS_CANDI_URI="http://example.com/slowmo#HasCandidate"

jq --arg hascandi "${HAS_CANDI_URI}" \
  '.[$hascandi] | length' \
  ${PCON_DIR}/cansmash_out/med_cs.json

#jq '."http://example.com/slowmo#HasCandidate" | length' med_cs.json
