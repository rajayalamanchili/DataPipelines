#!/bin/bash

export MLFLOW_TRACKING_URL=$(terraform output mlflow_tracking_server_url)

if [[ $MLFLOW_TRACKING_URL == *"No outputs found"* ]]; 
then
    echo "No terraform outputs found: Running terraform commands"
    terraform init -input=false
    terraform plan -out=tfplan -input=false
    terraform apply -input=false tfplan
    export MLFLOW_TRACKING_URL=$(terraform output mlflow_tracking_server_url)
fi

echo "MLFLOW tracking url: $MLFLOW_TRACKING_URL"