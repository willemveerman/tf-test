region = "eu-west-1"
profile = "wjav.admin"

ami = "ami-0a166fb5b1a5d9532" # regional amzn2-ami-hvm-2.0.20181114-x86_64-ebs

vpc-cidr = "10.10.10.0/24"
public_subnets = ["10.10.10.0/27", "10.10.10.32/27", "10.10.10.64/27"]

private_subnets = ["10.10.10.96/27", "10.10.10.128/27", "10.10.10.160/27"]


