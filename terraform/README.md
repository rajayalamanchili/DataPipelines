1. Install Terraform CLI:

https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update

sudo apt-get install terraform

2. Instal AWS CLI:

https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

cat /etc/os-release

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

unzip awscliv2.zip

sudo ./aws/install

rm -f awscliv2.zip
rm -rf aws

3. Run Terraform

set AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY

terraform init
terraform plan
terraform apply
terraform destroy