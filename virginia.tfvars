region = "us-east-1"
profile = "wjav.admin"

ami = "ami-0b8d0d6ac70e5750c" # regional amzn2-ami-hvm-2.0.20181114-x86_64-ebs

vpc-cidr = "10.10.11.0/24"
public_subnets = ["10.10.11.0/27", "10.10.11.32/27", "10.10.11.64/27", "10.10.11.96/27"]
