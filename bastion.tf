resource "aws_instance" "bastion" {
  ami                    = "${var.ami}"
  instance_type          = "t2.small"
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]

  #subnet_id                   = "${data.aws_subnet.bastion_subnet.id}"
  subnet_id                   = "${aws_subnet.public.1.id}"
  associate_public_ip_address = true
}

# As a more flexible alternative, you could specify a particular AZ
# using the code below
# data "aws_subnet" "bastion_subnet" {
#   vpc_id            = "${aws_vpc.vpc.id}"
#   availability_zone = "${var.region}${var.bastion_az}"

#   filter {
#     name   = "tag:Name"
#     values = ["PUBLIC-*"]
#   }
# }

resource "aws_security_group" "bastion" {
  vpc_id = "${aws_vpc.vpc.id}"

  ingress = [
    {
      from_port   = "22"
      to_port     = "22"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "bastion_eip" {
  instance = "${aws_instance.bastion.id}"
  vpc      = true

  tags = {
    Name = "Bastion EIP"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.bastion.id}"
  allocation_id = "${aws_eip.bastion_eip.id}"
}
