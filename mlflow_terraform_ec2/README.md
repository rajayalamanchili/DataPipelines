# Setting development environment codespaces

## Install Terraform and AWS CLI

### 1. Install Terraform CLI

Ref: <https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli>

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
```

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
```

```bash
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
```

```bash
sudo apt update
```

```bash
sudo apt-get install terraform
```

### 2. Instal AWS CLI

Ref: <https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html>

``` bash
<!--- identify os version --->
cat /etc/os-release
```

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
```

```bash
unzip awscliv2.zip
```

```bash
sudo ./aws/install
```

```bash
<!--- Optional: to remove downloaded files --->
rm -f awscliv2.zip
rm -rf aws
```

## Start MLFLOW from EC2

- ### Connect to ec2 created by Terraform and start mlflow tracking server (manual)

    #### 1. Setup s3, RDS, and ec2 for mlflow 

    set up resources for mlflow as explained: [link](https://github.com/DataTalksClub/mlops-zoomcamp/blob/main/02-experiment-tracking/mlflow_on_aws.md)

    #### 2. connect to ec2 instance

    ```bash
    ssh -i <PRIVATE-KEY-FILENAME> <USERNAME>@<PUBLIC IP>
    ```

    #### 3. install libraries

    ```bash
    sudo yum update
    pip3 install mlflow boto3 psycopg2-binary
    ```

    #### 4. set aws credentials 

    ```bash
    aws configure # you'll need to input your AWS credentials here
    ```

    #### 5. start mlflow server 

    ```bash
    mlflow server -h 0.0.0.0 -p 5000 --backend-store-uri postgresql://DB_USER:DB_PASSWORD@DB_ENDPOINT:5432/DB_NAME --default-artifact-root s3://S3_BUCKET_NAME
    ```

    #### 6. Access mlflow server in browser 

    ```
    http://<EC2_PUBLIC_DNS>:5000
    ```

- ### 2. start mlflow server with terraform on ec2 and output tracking url

    Current folder has the terraform modules to create s3, rds, vpc, ec2 resources and to install, start MLFLOW server in ec2

    ```bash
    ├── main.tf
    ├── modules
    │   ├── db
    │   │   ├── main.tf
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   ├── ec2
    │   │   ├── iamrole.tf
    │   │   ├── main.tf
    │   │   ├── outputs.tf
    │   │   ├── user_data.sh
    │   │   └── variables.tf
    │   ├── s3
    │   │   ├── main.tf
    │   │   └── variables.tf
    │   └── vpc
    │       ├── main.tf
    │       ├── networking.tf
    │       ├── outputs.tf
    │       └── variables.tf
    ├── setup.sh
    └── variables.tf
    ```

    Run shell script to automatically create resources and output MLFLOW tracking link

    ```bash
    . ./setup.sh
    ```

    ```bash
    <!--- Optional: to remove resources created --->
    terraform destroy
    ```
