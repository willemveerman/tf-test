variable instance_size {}

variable ami_id {}

variable subnet_ids {
  type = "list"
}

variable vpc_id {}

variable region {}

variable lc_name {}

variable security_groups {}

variable desired_capacity {}

variable max_size {}

variable min_size {}

variable tags {
  type = "list"
}

variable "public_ip" {}
