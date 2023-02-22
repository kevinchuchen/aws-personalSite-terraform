terraform {
    required_providers {
        aws= {
            source = "hashicorp/aws"
            version = "~>4.16"
        }
    }
    backend "s3" {
        bucket = var.s3-bucket-name
        key    = ".terraform/terraform.tfstate"
        region = "us-east-1"
    }
    required_version = ">= 1.2.0"

}