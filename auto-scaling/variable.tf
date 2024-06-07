variable "image_id" {
    type = string
}

variable "instance_type" {
    type = string
}

variable "key_name" {
    type = string
}

variable "vpc_id" {
    type = string
}

variable "vpc_cidr_block" {
    type = string
}

variable "tags" {
    type = map(string)
}

variable "availability_zone" {
    type = list(string)
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

variable "alb_sg" {
    type = string
}

variable "alb_private_sg" {
    type = string
}


variable "alb_target_group_arns" {
    type = set(string)
}

variable "alb_private_target_group_arns" {
    type = set(string)
}