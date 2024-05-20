variable "env" {
  default = "dev"
}

variable "app_name" {
  default = "mlops-training"
}

variable "region" {
  default = "us-east-2"
}

variable "ecr_image_tag" {
  type    = string
  default = "latest"
}