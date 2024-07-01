variable "private_subnet_3" {
  type = string
}

variable "private_subnet_4" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr_block" {
    type = string
}

variable "username" { # db username
  type = string
}

variable "password" { # db password
  type = string
}

variable "engine_version" { # db engine version
    type = string
}

variable "instance_class" { # database instance type
    type = string
}