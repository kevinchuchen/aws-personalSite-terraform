#Creates an AWS cognito resource

resource "aws_cognito_user_pool" "cognitoPool" {
  name = var.cognitoPool-name
}
resource "aws_cognito_user_pool_client" "cognitoClient" {
  name = var.cognitoClient-name
  user_pool_id = aws_cognito_user_pool.cognitoPool.id
}
