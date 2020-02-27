#!/usr/bin/env bash
ROLE_ARN="arn:aws:iam::931601792379:role/test-NeptuneLoadFromS3Role-1V2EA5CN5WOCO"
CLUSTER="neptunedbcluster-puawcugefxks"

aws neptune add-role-to-db-cluster\
  --role-arn ${ROLE_ARN} \
  --db-cluster-identifier ${CLUSTER} 
