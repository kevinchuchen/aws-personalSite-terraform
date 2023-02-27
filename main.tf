provider "aws" {
    region = "us-east-1"
    access_key = var.AWS_ACCESS_KEY_ID
    secret_key = var.AWS_SECRET_ACCESS_KEY
}

# module "create-codecommit-repo"{
#     source = "./modules/CodeCommit-repo"
# }

module "create-amplify-env"{
    source = "./modules/awsAmplify"
    source-repo = "https://github.com/aws-samples/aws-serverless-webapp-workshop.git"
}