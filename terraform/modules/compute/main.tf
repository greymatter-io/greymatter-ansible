data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

module "ssh_key_pair" {
  source                = "git::https://github.com/cloudposse/terraform-aws-key-pair.git?ref=master"
  name                  = "greymatterkey"
  ssh_public_key_path   = "secrets"
  generate_ssh_key      = "true"
  private_key_extension = ".pem"
  public_key_extension  = ".pub"
}

resource "aws_instance" "instances" {
  count         = var.instance_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = module.ssh_key_pair.key_name
  # subnet_id     = var.pub_sub_1_id
  subnet_id     = element(var.gm_public_subnets, count.index)
  associate_public_ip_address = true
  vpc_security_group_ids = [
    var.gm_sg_id,
  ]

  tags = {
    Name  = element(var.instance_name, count.index)
    element(var.cluster_tag, count.index) = ""
  }
}

# module "ec2_cluster" {
#   source                 = "terraform-aws-modules/ec2-instance/aws"
#   version                = "~> 2.0"

#   instance_count         = var.instance_count
#   name                   = var.instance_name

#   ami                    = data.aws_ami.ubuntu.id
#   instance_type          = var.instance_type
#   key_name               = module.ssh_key_pair.key_name
#   monitoring             = true
#   vpc_security_group_ids = [var.gm_sg_id]
#   subnet_ids             = var.gm_public_subnets

#   # tags = {
#   #   Name  = element(var.instance_name, count.index)
#   #   element(var.cluster_tag, count.index) = ""
#   # }
# }

# Create record sets for the instances
resource "aws_route53_record" "priv_record_set" {
  count   = var.instance_count
  zone_id = var.private_zone_id
  name    = "${element(var.instance_name, count.index)}.${var.private_zone_name}"
  type    = "A"
  ttl     = "300"
  records = ["${element(aws_instance.instances.*.private_ip, count.index)}"]
}