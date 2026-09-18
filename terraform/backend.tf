terraform {
  backend "s3" {
    bucket  = "terraform-state-kubernetes-learning-project"
    region  = "us-east-1"
    encrypt = true
  }
}