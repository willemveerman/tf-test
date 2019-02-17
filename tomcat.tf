resource "aws_instance" "tomcat" {
  ami                         = "${data.aws_ami.tomcat.id}"
  instance_type               = "t2.small"
  vpc_security_group_ids      = ["${aws_security_group.tomcat.id}"]
  
  #subnet_id                   = "${data.aws_subnet.tomcat_subnet.id}"
  subnet_id                   = "${aws_subnet.private.1.id}"
  associate_public_ip_address = false
}

data "aws_caller_identity" "current" {}

data "aws_ami" "tomcat" {
  most_recent = true
  owners      = ["${data.aws_caller_identity.current.account_id}"]

  filter {
    name   = "name"
    values = ["tomcat-${var.tomcat_version}_*"]
  }
}

# Once subnets are created you can specify an AZ using the code below.
# data "aws_subnet" "tomcat_subnet" {
#   vpc_id            = "${aws_vpc.vpc.id}"
#   availability_zone = "${var.region}${var.tomcat_az}"

#   filter {
#     name   = "tag:Name"
#     values = ["PRIVATE-*"]
#   }
# }

resource "aws_security_group" "tomcat" {
  vpc_id = "${aws_vpc.vpc.id}"

  ingress = [
    {
      from_port       = "8080"
      to_port         = "8080"
      protocol        = "tcp"
      security_groups = ["${aws_security_group.nginx-security-group.id}"]
    },
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route53_record" "tomcat" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "tomcat"
  type    = "A"
  ttl     = "172800"
  records = ["${aws_instance.tomcat.private_ip}"]

}