#use "aws configure" to authenticate

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>5.27.0"
    }
  }
}

provider "aws" {
    region = "us-east-1"
    alias = "east1"
}

provider "aws" {
    region = "us-east-2"
    alias = "east2"
}
