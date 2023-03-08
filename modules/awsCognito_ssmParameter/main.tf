#Creates an AWS cognito resource

resource "aws_cognito_user_pool" "cognitoPool" {
  name = var.cognitoPool-name
}
resource "aws_cognito_user_pool_client" "cognitoClient" {
  name = var.cognitoClient-name
  user_pool_id = aws_cognito_user_pool.cognitoPool.id
}

#Creates SSM Parameters to import to the webapp
resource "aws_ssm_parameter" "userPoolId" {
  name  = var.userPoolId_name
  type  = "String"
  value = aws_cognito_user_pool.cognitoPool.id
}

resource "aws_ssm_parameter" "clientId" {
  name  = var.clientId_name
  type  = "String"
  value = aws_cognito_user_pool_client.cognitoClient.id
}

resource "aws_ssm_parameter" "nativeClientId" {
  name  = var.nativeClientId_name
  type  = "String"
  value = aws_cognito_user_pool_client.cognitoClient.id
}