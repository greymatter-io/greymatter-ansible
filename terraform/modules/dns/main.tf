resource "aws_route53_zone" "private" {
  name = var.private_route53_zone_name

  vpc {
    vpc_id = var.vpc_id
  }
}