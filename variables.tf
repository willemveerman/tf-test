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
