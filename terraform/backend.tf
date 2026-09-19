terraform {
  backend "s3" {
    bucket  = "terraform-state-kubernetes-learning-project"
    key     = "hetzner/k3s/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}