variable "ami" {
  type    = string
  default = "ami-0ddda618e961f2270"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "instance_name" {
  type    = string
  default = "sample-server"
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "subnet_id" {
  type    = string
  default = ""
}

variable "key_pair_name" {
  type = string
}

variable "MLFLOW_ARTIFACT_URL_SSM_NAME" {
  type = string
}

variable "MLFLOW_DB_URL_SSM_NAME" {
  type = string
}

variable "MLFLOW_PORT" {
  type    = number
  default = 5000
}