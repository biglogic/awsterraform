terraform {
  backend "s3" {
    bucket = "tf-biglogic-states"
    key    = "leo/terraform.tfstate"
    region = "us-east-1"
  }
}