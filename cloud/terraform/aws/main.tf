provider "aws" {
  region = var.region
}

resource "aws_security_group" "tpot_public" {
  name        = "t-pot-public"
  description = "T-Pot Honeypot Public"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 64000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 64000
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "T-Pot Public"
  }
}

resource "aws_security_group" "tpot_private" {
  name        = "t-pot-private"
  description = "T-Pot Honeypot Private"
  vpc_id      = module.vpc.vpc_id
  
  ingress {
    from_port   = 64294
    to_port     = 64294
    protocol    = "tcp"
    cidr_blocks = var.admin_ips
  }

  ingress {
    from_port   = 64295
    to_port     = 64295
    protocol    = "tcp"
    cidr_blocks = var.admin_ips
  }
  
  ingress {
    from_port   = 64297
    to_port     = 64297
    protocol    = "tcp"
    cidr_blocks = var.admin_ips
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "T-Pot Private"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.21.0"

  name = var.vpc_name

  cidr = "172.16.0.0/16"

  azs                 = ["us-west-2b"]
  public_subnets      = ["172.16.0.0/22"]
  private_subnets     = []

  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_nat_gateway   = false

  public_subnet_tags = {
    Name = "honeypot-public"
  }

  tags = {
    Owner       = "platform"
    Environment = "production"
  }

  vpc_tags = {
    Name = var.vpc_name
  }
}

resource "aws_spot_instance_request" "tpot" {
  ami           = var.ec2_ami[var.region]
  spot_price    = "0.0263"
  wait_for_fulfillment = "true"
  instance_type = var.ec2_instance_type
  key_name      = var.ec2_ssh_key_name
  subnet_id     = module.vpc.public_subnets[0]
  tags = {
    Name = "T-Pot Honeypot"
  }
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 10
    delete_on_termination = true
  }
  user_data              = "${file("../cloud-init.yaml")}    content: ${base64encode(file("../tpot.conf"))}"
  vpc_security_group_ids = [aws_security_group.tpot_public.id, aws_security_group.tpot_private.id]
  associate_public_ip_address = true
}

resource "aws_ebs_volume" "tpot_data" {
  availability_zone = "us-west-2b"
  size = 20
  type = "standard"
}

resource "aws_volume_attachment" "tpot_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.tpot_data.id
  instance_id = aws_spot_instance_request.tpot.spot_instance_id
}