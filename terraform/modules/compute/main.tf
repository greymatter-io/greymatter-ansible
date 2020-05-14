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

resource "aws_instance" "instances" {
  count         = var.instance_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.pub_sub_1_id
  associate_public_ip_address = true
  vpc_security_group_ids = [
    var.gm_sg_id,
  ]

  tags = {
    Name  = element(var.instance_tags, count.index)
  }
}

# Creater record sets for the servers
resource "aws_route53_record" "priv_record_set" {
  count   = var.instance_count
  zone_id = var.private_zone_id
  name    = "${element(var.instance_tags, count.index)}.${var.private_zone_name}"
#   name    = "${element(var.example_gsuite, count.index)}"
  type    = "A"
  ttl     = "300"
  records = ["${element(aws_instance.servers.*.private_ip, count.index)}"]
}