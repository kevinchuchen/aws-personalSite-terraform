terraform {
    cloud {
        organization ="LCC-personalSite"
        workspaces {
            name ="personalSite-terraform"
        }

    }
    required_providers {
        aws= {
            source = "hashicorp/aws"
            version = "~>4.16"
        }
    }
    required_version = ">= 1.2.0"

}