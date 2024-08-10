module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = var.vpc_tags
}

resource "aws_security_group" "public_sg" {
  vpc_id = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.allowed_egress_cidr_blocks
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_blocks
  }

  tags = {
    Name = var.public_sg_name
  }
}

resource "aws_instance" "public" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnets[0]
  key_name                    = var.key_name
  security_groups             = [aws_security_group.public_sg.id]
  associate_public_ip_address = true
  tags                        = var.instance_tags_1
}
