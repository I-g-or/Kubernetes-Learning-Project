terraform {
  backend "s3" {
    bucket  = "terraform-state-kubernetes-learning-project"
    key     = "hetzner/k3s/terraform.tfstate"
    region  = var.aws_region
    encrypt = true
  }
}