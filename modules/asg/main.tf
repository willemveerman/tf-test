resource "aws_launch_configuration" "lc" {
  name_prefix                 = "${var.lc_name}-"
  instance_type               = "${var.instance_size}"
  image_id                    = "${var.ami_id}"
  security_groups             = ["${var.security_groups}"]
  associate_public_ip_address = "${var.public_ip}"
  user_data                   = "${var.user_data}"
  key_name                    = "${var.key_name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name = "${var.lc_name}"

  desired_capacity = "${var.desired_capacity}"
  max_size         = "${var.max_size}"
  min_size         = "${var.min_size}"

  vpc_zone_identifier  = ["${var.subnet_ids}"]
  launch_configuration = "${aws_launch_configuration.lc.name}"

  tags = "${var.tags}"

  lifecycle {
    create_before_destroy = true
  }
}
