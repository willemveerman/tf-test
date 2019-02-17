module "nginx" {
  source          = "modules/asg"
  lc_name         = "${var.nginx_lc_name}"
  instance_size   = "${var.nginx_instance_size}"
  ami_id          = "${var.ami}"
  subnet_ids      = "${aws_subnet.public.*.id}"
  vpc_id          = "${aws_vpc.vpc.id}"
  region          = "${var.region}"
  security_groups = "${aws_security_group.nginx-security-group.id}"
  public_ip       = "true"

  desired_capacity = 1
  max_size         = 1
  min_size         = 0

  tags = ["${concat(
    list(
      map("key", "Name", "value", "${var.nginx_lc_name}", "propagate_at_launch", true),
      map("key", "Environment", "value", "${terraform.workspace}", "propagate_at_launch", true),
    )
  )
  }"]
}

data "aws_ami" "nginx" {
  most_recent = true
  owners      = ["${data.aws_caller_identity.current.account_id}"]

  filter {
    name   = "name"
    values = ["nginx-${var.nginx_version}_*"]
  }
}

resource "aws_security_group" "nginx-security-group" {
  vpc_id = "${aws_vpc.vpc.id}"

  ingress = [
    {
      from_port   = "80"
      to_port     = "80"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = "443"
      to_port     = "443"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port       = "22"
      to_port         = "22"
      protocol        = "tcp"
      security_groups = ["${aws_security_group.bastion.id}"]
    },
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# data "aws_instance" "nginx" {
#   filter {
#     name   = "tag:Name"
#     values = ["${var.nginx_lc_name}"]
#   }
# }


# output "nginx_domain" {
#   value = "${data.aws_instance.nginx.public_dns}"
# }

