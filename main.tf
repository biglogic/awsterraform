module "vpc" {
  source  = "github.com/biglogic/aws-terraform-vpc"
  region  = var.region
  env     = var.env
  project = var.project
  cidr    = var.cidr
}