variable "admin_ips" {
  default     = ["127.0.0.1/32"]
  description = "admin IP addresses in CIDR format"
}

variable "vpc_name" {
  description = "Name of AWS VPC"
  default     = "honeypot"
}

variable "region" {
  description = "AWS region to launch servers"
  default     = "us-west-2"
}

variable "ec2_ssh_key_name" {
  default = "default"
}

# https://aws.amazon.com/ec2/instance-types/
# t3.large = 2 vCPU, 8 GiB RAM
variable "ec2_instance_type" {
  default = "t3.large"
}

# Refer to https://wiki.debian.org/Cloud/AmazonEC2Image/Buster
variable "ec2_ami" {
  type = map(string)
  default = {
    "ap-east-1"      = "ami-5c9de72d"
    "ap-northeast-1" = "ami-089df01b498a97d27"
    "ap-northeast-2" = "ami-0d8e8a32d0f4badb3"
    "ap-south-1"     = "ami-0caf1694efa7ed29e"
    "ap-southeast-1" = "ami-0293127e9f23d992a"
    "ap-southeast-2" = "ami-05850fe0bf797791c"
    "ca-central-1"   = "ami-00a1484736448e060"
    "eu-central-1"   = "ami-01eb7b0c1119f2550"
    "eu-north-1"     = "ami-0df5dd9cdb4d0246e"
    "eu-west-1"      = "ami-0e9cc061cd3259f22"
    "eu-west-2"      = "ami-042796b8e41bb5fad"
    "eu-west-3"      = "ami-088796ca618e3533f"
    "me-south-1"     = "ami-04340529d06f3db2b"
    "sa-east-1"      = "ami-0994f9ee573d5cadc"
    "us-east-1"      = "ami-0dedf6a6502877301"
    "us-east-2"      = "ami-05d9978d11a05da49"
    "us-west-1"      = "ami-0d946bbbd372c70b2"
    "us-west-2"      = "ami-018774bc9055cf127"
  }
}
