terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = "6.36.0"
    }
  }
}

provider "aws" {
  region = var.region
  # to set those values, run 'export TF_VAR_access_key' and 'TF_VAR_secret_key'
  access_key = var.access_key
  secret_key = var.secret_key
}