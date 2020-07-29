variable "vpc_cidr_block" {
    type = string
    description = "Cidr block for VPC"
    default = "10.0.0.0/16"
}

variable "pub_sub_cidr_blocks" {
    type = list(string)
    description = "List of cidr blocks for the pubclic subnets"
    default = ["10.0.1.0/24","10.0.2.0/24"]
}