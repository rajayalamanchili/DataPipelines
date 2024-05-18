#!/bin/bash

sudo yum update -y && sudo yum install python3-pip -y
sudo pip3 install --upgrade pip

pip3 install --ignore-installed mlflow boto3 psycopg2-binary # not recommended to use --ignore-installed option

echo "${samplevar}"