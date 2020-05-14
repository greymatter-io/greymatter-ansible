variable "key_name" {
  type        = string
  default     = "training_gm"
}

variable "instance_count" {
  default     = "6"
}

variable "instance_type" {
  default     = "t2.micro"
}

variable "instance_tags" {
  type = list(string)
  default = ["gm_control_api_ubuntu", "gm_control_ubuntu","gm_proxy_ubuntu","gm_ijwt_ubuntu","gm_data_ubuntu","gm_catalog_ubuntu"]
}

variable "pub_sub_1_id" {}

variable "gm_sg_id" {}

variable "private_zone_id" {}

variable "private_zone_name" {}


