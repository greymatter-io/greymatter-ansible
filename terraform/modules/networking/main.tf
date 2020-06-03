resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
  
  tags = {
    Name = "gm_vpc"
  }

  provisioner "local-exec" {
    command = "echo gm_control_vpc_id: {${aws_vpc.vpc.id}} >> ../ansible/playbooks/roles/ansible-role-control/defaults/main.yml"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "gm_public_subnet_1"
  }
}
# resource "aws_subnet" "public_subnet_2" {
#   vpc_id                  = "${aws_vpc.vpc.id}"
#   cidr_block              = "10.0.1.0/24"
#   availability_zone       = "${data.aws_availability_zones.available.names[1]}"
#   map_public_ip_on_launch = true
#   tags = {
#     Name = "public subnet 2"
#   }
# }

# resource "aws_subnet" "private_subnet_1" {
#   vpc_id                  = "${aws_vpc.vpc.id}"
#   cidr_block              = "10.0.3.0/24"
#   availability_zone       = "${data.aws_availability_zones.available.names[1]}"
#   map_public_ip_on_launch = true
#   tags = {
#     Name = "private_subnet_1"
#   }
# }

# resource "aws_subnet" "private_subnet_2" {
#   vpc_id                  = "${aws_vpc.vpc.id}"
#   cidr_block              = "10.0.4.0/24"
#   availability_zone       = "${data.aws_availability_zones.available.names[0]}"
#   map_public_ip_on_launch = true
#   tags = {
#     Name = "private_subnet_1"
#   }
# }

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "gm_igw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "gm_rt"
  }
}

resource "aws_route_table_association" "rta_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.rt.id
}
# resource "aws_route_table_association" "rta_2" {
#   subnet_id      = "${aws_subnet.public_subnet_2.id}"
#   route_table_id = "${aws_route_table.rt.id}"
# }

resource "aws_security_group" "sg" {
  name        = "gm_securitygroup"
  description = "Greymatter Security Group"

  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "gm_sg"
  }
}

resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "ingress_within_vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.vpc.cidr_block]
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "egress_allow_all" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
}

# Define an Ansible var_file containing Terraform variable values
data "template_file" "tf_ansible_vars_file" {
  template = "${file("./tf_ansible_vars_file.yml.tpl")}"
  vars = {
    vpc_id = aws_vpc.vpc.id
  }
}

# Render the Ansible var_file containing Terrarorm variable values
resource "local_file" "tf_ansible_vars_file" {
  content  = data.template_file.tf_ansible_vars_file.rendered
  filename = "../ansible/group_vars/tf_ansible_vars_file.yml"
}