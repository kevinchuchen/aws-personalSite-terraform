provider "aws" {
    region = "us-east-1"
    access_key = var.AWS_ACCESS_KEY_ID
    secret_key = var.AWS_SECRET_ACCESS_KEY
}
#TODO
#create IAM role for Amplify backend
#create amplify environment and deploy app
#app install for to give aws Github permissions


# module "create-codecommit-repo"{
#     source = "./modules/CodeCommit-repo"
# }

module "create-amplify-env"{
    source = "./modules/awsAmplify"
    source-repo = "https://github.com/kevinchuchen/webapp-wildRydes/tree/main"
}