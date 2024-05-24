FROM python:3.12.3

RUN pip install -U pip

RUN pip install mlflow psycopg2-binary boto3
    
RUN mkdir /mlflow/

CMD mlflow server \
    --host 0.0.0.0 \
    --port 5000 \
    --default-artifact-root ${MLFLOW_ARTIFACT_BUCKET} \
    --backend-store-uri ${MLFLOW_BACKEND_DB_URL}