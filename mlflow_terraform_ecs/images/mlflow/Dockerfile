FROM python:3.12.3

RUN pip install -U pip

RUN pip install \
    mlflow \
    psycopg2-binary \
    boto3 & \
    mkdir /mlflow/

CMD mlflow server \
    --host 0.0.0.0 \
    --port 5000 \
    --default-artifact-root ${BUCKET} \
    --backend-store-uri postgresql://${DB_USER}:${DB_PASSWORD}@${DB_ENDPOINT}:5432/${DB_NAME}