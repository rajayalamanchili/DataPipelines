#!/bin/bash

sudo yum update -y && sudo yum install python3-pip -y
sudo pip3 install --upgrade pip

pip3 install --ignore-installed mlflow boto3 psycopg2-binary # not recommended to use --ignore-installed option

export MLFLOW_ARTIFACT_URL="$(aws ssm get-parameter --name ${MLFLOW_ARTIFACT_URL_SSM_NAME} --with-decryption | jq --raw-output '.Parameter.Value')"
export MLFLOW_DB_URL="$(aws ssm get-parameter --name ${MLFLOW_DB_URL_SSM_NAME} --with-decryption | jq --raw-output '.Parameter.Value')"

echo "MLFLOW_ARTIFACT_URL: $MLFLOW_ARTIFACT_URL"
echo "MLFLOW_DB_URL: $MLFLOW_DB_URL"

mlflow server -h 0.0.0.0 -p 5000 --backend-store-uri $MLFLOW_DB_URL --default-artifact-root $MLFLOW_ARTIFACT_URL
