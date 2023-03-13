provider "aws" {
    region = "us-east-1"
    access_key = var.AWS_ACCESS_KEY_ID
    secret_key = var.AWS_SECRET_ACCESS_KEY
}
#TODO
#DONE -- create IAM role for Amplify backend
#DONE -- create amplify environment and deploy app
#DONE -- create Cognito environment and link to web app
#DONE -- Create DDB
#DONE -- Create IAM role for Lambda function
#DONE -- Create Lambda function
#DONE -- API Gateway creation
#Integrate API GW with lambda
#Documentations

module "create-Cognito-resource"{
    source = "./modules/awsCognito_ssmParameter"
    cognitoPool-name = "wild-rydes-userPool"
    cognitoClient-name = "wildRydesClient"

    userPoolId_name  = "/amplify/${module.create-amplify-env.Amplify-App-ID}/prod/userPoolId"
    clientId_name  = "/amplify/${module.create-amplify-env.Amplify-App-ID}/prod/webClientId"
    nativeClientId_name  = "/amplify/${module.create-amplify-env.Amplify-App-ID}/prod/nativeClientId"

}

module "create-API-Gateway"{
    source = "./modules/API-Gateway"
    API-GW-name = "WildRydes"
    stage-name = "prod"
    cognito-UserPool-Arn = module.create-Cognito-resource.cognito-userPool-arn
    lambda-function-arn = module.create-lambda-function.lambda_function_arn
    lambda-invoke-arn = module.create-lambda-function.lambda_invoke_arn

}
module "api-gateway-enable-cors" {
  source  = "squidfunk/api-gateway-enable-cors/aws"
  version = "0.3.3"
  api_id          = module.create-API-Gateway.API-GW-ID
  api_resource_id = module.create-API-Gateway.API-GW-Resource-ID
}

module "create-amplify-env"{
    source = "./modules/awsAmplify"
    source-repo = "https://github.com/kevinchuchen/webapp-wildRydes"
    GITHUB_ACCESS_TOKEN = var.GITHUB_ACCESS_TOKEN
    AMPLIFY_WEBCLIENT_ID = module.create-Cognito-resource.clientId
    AMPLIFY_USERPOOL_ID = module.create-Cognito-resource.userPoolId
    AMPLIFY_NATIVECLIENT_ID = module.create-Cognito-resource.clientId
    API-GW-InvokeUrl = module.create-API-Gateway.API-GW-InvokeUrl
}


module "create-DynamoDB-table"{
    source = "./modules/DynamoDB"
}

module "create-lambda-function"{
    source = "./modules/Lambda"
    lambda-source = "${path.module}/modules/Lambda/NodeJS/index.js"
    lambda-output = "${path.module}/modules/Lambda/NodeJS/lambda.zip"
    lambda-dynamoDB-ARN = module.create-DynamoDB-table.DynamoDB-ARN
}