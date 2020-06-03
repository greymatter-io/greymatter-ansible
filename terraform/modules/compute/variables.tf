variable "instance_count" {
  default     = "6"
}

variable "instance_type" {
  default     = "t2.micro"
}

variable "instance_name" {
  type = list(string)
  default = ["gm_control_api", "gm_control","gm_edge","gm_ijwt","gm_idata","gm_catalog"]
}

variable "cluster_tag" {
  type = list(string)
  default = ["gm:cluster:control-api:8080", "control","gm:cluster:edge:8080","gm:cluster:internal-jwt-security:8080","gm:cluster:data-internal:8080","gm:cluster:catalog:8080"]
}

variable "pub_sub_1_id" {}

variable "gm_sg_id" {}

variable "private_zone_id" {}

variable "private_zone_name" {}


