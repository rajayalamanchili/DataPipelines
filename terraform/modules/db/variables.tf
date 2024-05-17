variable "env" {
  type = string
}

variable "app_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "mlflow_db_name" {
  type    = string
  default = "mlflow_db"
}