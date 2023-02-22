provider "aws" {
    region = "us-east-1"
}

module "" ""{
    source = "./modules/s3-bucket"
}