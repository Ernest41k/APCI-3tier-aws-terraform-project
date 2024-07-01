variable "vpc_cidr_block" {
    type = string
}

variable "public_subnet_cidr_blocks" {
    type = list(string)
}


variable "private_subnet_cidr_blocks" {
    type = list(string)
}

variable "availability_zone" {
    type = list(string)
}

variable "image_id" {
    type = string
}

variable "instance_type" {
    type = string
}

variable "key_name" {
    type = string
}

variable "ssl_policy" {
    type = string
}

variable "certificate_arn" {
    type = string
}

variable "zone_id" {
    type = string
}

variable "dns_name" {
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

# variable "public_subnet_1" {
#     type = string
# }

# variable "public_subnet_2" {
#     type = string
# }