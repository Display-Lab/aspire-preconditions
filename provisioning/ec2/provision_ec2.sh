#!/usr/bin/env bash

# PROVISION FUSEKI STACK
echo "Provisioning Fuseki Stack"
: ${STACK_NAME:="fuseki"} 
: ${AWS_DEFAULT_KEY_NAME:="my-useast-1-key"}

aws cloudformation create-stack --stack-name $STACK_NAME\
  --capabilities "CAPABILITY_NAMED_IAM" \
  --template-body file://stack_cf.yaml \
  --parameters '[{"ParameterKey":"KeyName","ParameterValue":'${AWS_DEFAULT_KEY_NAME}'}]'

if aws cloudformation wait stack-create-complete --stack-name ${STACK_NAME}; then
    echo "Stack ${STACK_NAME} creation complete."
else
    echo "Stack ${STACK_NAME} creation FAILED."
    exit 1
fi

# ASSIGN FUSEKI IP TO USER SPECIFIC HOSTS FILE

# Specify the output keys to be re-written in VAR=VAL style for export.
KEYS='("FusekiIp","SshKeyName")'

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

# Declare and echo env var
for s in ${VARS}; do
  echo $s
  declare $s
done

# Write ssh config as convenience for referencing the host
read -r -d '' SSHCONFIG <<SSHCONFIG
Host fusekihost
  HostName ${FusekiIp}
  User ec2-user
  IdentityFile ${AWS_DEFAULT_KEY_NAME}.pem
  StrictHostKeyChecking no
  PasswordAuthentication no
  UserKnownHostsFile /dev/null
SSHCONFIG

echo "${SSHCONFIG}" > ~/.ssh/aws_ssh_config
chmod 0600 ~/.ssh/aws_ssh_config

echo "Done."
