#!/usr/bin/env bash

# To put stack vars into current env, source this file:
#  . ./stack_vars_to_env.sh

# Provide default stack name if ENV doesn't
#   Refs for explanation:
#     https://stackoverflow.com/a/307735/1180551
#     https://stackoverflow.com/a/2440987/1180551
: ${STACK_NAME:="test"} 

# Specify the output keys to be re-written in VAR=VAL style for export.
KEYS='("BastionIp","DBClusterEndpoint","DBClusterPort","DBClusterId", "NeptuneLoadFromS3IAMRoleArn")'

# JQ filter to grab the selected OutputKeys from describe-stack
read -r -d '' JQ_FILTER <<'FILT'
.Stacks[0].Outputs | 
  map({(.OutputKey): .OutputValue}) | add |
  . |= with_entries( select(.key as $k| $keys | index($k)) )
FILT

# Obtain output of stack creation,
#  filter for keys of interest keys,
#  and finally reformat for bash exporting
VARS=$(\
  aws cloudformation describe-stacks --stack-name ${STACK_NAME} |\
  jq --arg keys "$KEYS" "${JQ_FILTER}" |\
  jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]')

for s in ${VARS}; do
  export $s
done
