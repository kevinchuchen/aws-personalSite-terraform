output "userPoolId" {
    value = aws_cognito_user_pool.cognitoPool.id
    description = "The cognito user Pool ID"
}

output "clientId" {
    value = aws_cognito_user_pool_client.cognitoClient.id
    description = "The cognito client ID"
}

output "cognito-userPool-arn" {
    value = aws_cognito_user_pool.cognitoPool.arn
    description = "Cognito user pool ARN"
}