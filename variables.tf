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

variable "nginx_instance_size" {
  default = "t2.small"
}

variable "nginx_lc_name" {
    default = "nginx"
  
}
