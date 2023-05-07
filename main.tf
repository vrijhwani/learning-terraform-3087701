data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

data "aws_vpc" "default"{
  default = true
}

resource "aws_instance" "blog" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.instance_type
  
  vpc_security_group_ids = [module.blog-sg.security_group_id]

  tags = {
    Name = "Learning Terraform"
  }
}

module "blog-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.2"
  name = "blog-new"

  vpc_id = data.aws_vpc.default.id

  ingress_rules        = ["http-80-tcp", "https-443-tcp"]
  ingress_cidr_blocks  = ["0.0.0.0/0"]

  egress_rules        = ["all-all"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
}

resource "aws_security_group" "blog" {
  name = "blog"
  description = "Allow in all http and https traffic and allow all traffic out"
  
  vpc_id = data.aws_vpc.default.id

}