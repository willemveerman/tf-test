resource "aws_route53_zone" "private" {
  name = "tf-test.com"

  vpc {
    vpc_id = "${aws_vpc.vpc.id}"
  }
}