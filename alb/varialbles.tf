variable "vpc_id" {
    type = string
}

variable "public_subnet_1" {
    type = string
}

variable "public_subnet_2" {
    type = string
}

variable "private_subnet_1" {
    type = string
}

variable "private_subnet_2" {
    type = string
}

variable "tags" {
    type = map(string)
}

variable "public_sg" {
    type = string
}


variable "ssl_policy" {
    type = string
}

variable "certificate_arn" {
    type = string
}

