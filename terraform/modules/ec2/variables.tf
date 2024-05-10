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

variable "subnet_id" {
  type = string
  default = ""
}