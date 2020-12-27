resource "aws_vpc" "biglogic_vpc" {
  cidr_block           = var.cidr
  instance_tenancy     = "default"
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name    = "vpc-${var.aws-account}-${var.project}-${var.env}"
    env     = var.env
    project = var.project
  }
}