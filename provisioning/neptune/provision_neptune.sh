#!/usr/bin/env bash

echo "Provisioning Neptune Stack"

# Provide default stack name if ENV doesn't
#   Refs for explanation:
#     https://stackoverflow.com/a/307735/1180551
#     https://stackoverflow.com/a/2440987/1180551
: ${STACK_NAME:="test"} 
: ${AWS_DEFAULT_KEY_NAME:="my-useast-1-key"} 
export AWS_DEFAULT_KEY_NAME=aws-growls-useast-1

aws cloudformation create-stack --stack-name $STACK_NAME\
  --capabilities "CAPABILITY_IAM" \
  --template-body file://nept_stack_cf.yaml \
  --parameters '[{"ParameterKey":"Env","ParameterValue":"test"},{"ParameterKey":"DbInstanceType","ParameterValue":"db.r4.xlarge"},{"ParameterKey":"KeyName","ParameterValue":'${AWS_DEFAULT_KEY_NAME}'}]'

if aws cloudformation wait stack-create-complete --stack-name ${STACK_NAME}; then
    echo "Stack creation complete."
else
    echo "Stack creation FAILED."
    exit 1
fi

# Source environment variables
. get_stack_vars.sh

# Set up bastion host
ansible-playbook -i ${BastionIp}, -u ec2-user \
  --ssh-common-args '-o StrictHostKeyChecking=no' bastion_play.yml


echo -e "Bastion host ready:\nssh ec2-user@${BastionIp}"
echo -e "Add role to cluster:\naws neptune add-role-to-db-cluster "\
  "--role-arn ${NeptuneLoadFromS3IAMRoleArn} "\
  "--db-cluster-identifier ${DBClusterId}"
