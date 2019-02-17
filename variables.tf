variable "region" {}

variable "profile" {
  default = ""
}

variable "vpc-cidr" {}

variable "public_subnets" {
  description = "List of public subnets in the VPC."
  type        = "list"
  default     = []
}

variable "private_subnets" {
  description = "List of private subnets in the VPC."
  type        = "list"
  default     = []
}

variable "nginx_instance_size" {
  default = "t2.small"
}

variable "nginx_lc_name" {
  default = "nginx"
}

variable "ami" {}

variable "tomcat_version" {
  default = "2.2.0"
}

variable "nginx_version" {
  default = "1.12"
}
