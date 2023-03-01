provider "aws" {
    region = "us-east-2"
    access_key = var.AWS_ACCESS_KEY_ID
    secret_key = var.AWS_SECRET_ACCESS_KEY
}
#TODO
#DONE -- create IAM role for Amplify backend
#DONE -- create amplify environment and deploy app
#DONE -- app install for to give aws Github permissions
#DONE -- Create DDB
#DONE -- Create IAM role for Lambda function
#Create Lambda function

# module "create-codecommit-repo"{
#     source = "./modules/CodeCommit-repo"
# }

module "create-amplify-env"{
    source = "./modules/awsAmplify"
    source-repo = "https://github.com/kevinchuchen/webapp-wildRydes"
    GITHUB_ACCESS_TOKEN = var.GITHUB_ACCESS_TOKEN
}

# module "create-DynamoDB-table"{
#     source = "./modules/DynamoDB"
# }

# module "create-lambda-function"{
#     source = "./modules/Lambda"
#     lambda-dynamoDB-ARN = module.create-DynamoDB-table.DynamoDB-ARN
# }