#API Gateway acts as an entry point for the webapp to trigger lambda function

resource "aws_api_gateway_rest_api" "api-gateway" {
    name = "WildRydes-API-gateway"
}

resource "aws_api_gateway_authorizer" "api-GW-authorizer" {
    name = var.API-GW-name
    rest_api_id = aws_api_gateway_rest_api.api-gateway.id
    type = "COGNITO_USER_POOLS"
    provider_arns = [var.cognito-UserPool-Arn]
}

resource "aws_api_gateway_resource" "api-GW-resource" {
  parent_id   = aws_api_gateway_rest_api.api-gateway.root_resource_id
  path_part   = "ride"
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
}

resource "aws_api_gateway_method" "api-GW-POST" {
  rest_api_id   = aws_api_gateway_rest_api.api-gateway.id
  resource_id   = aws_api_gateway_resource.api-GW-resource.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.api-GW-authorizer.id
}

resource "aws_api_gateway_integration" "apiGW-Lambda-Integration" {
  rest_api_id   = aws_api_gateway_rest_api.api-gateway.id
  resource_id   = aws_api_gateway_resource.api-GW-resource.id
  http_method   = aws_api_gateway_method.api-GW-POST.http_method
  integration_http_method = "POST"
  type          = "AWS_PROXY"
  uri           = var.lambda-invoke-arn
}

# resource "aws_api_gateway_method" "example" {
#   authorization = "NONE"
#   http_method   = "GET"
#   resource_id   = aws_api_gateway_resource.example.id
#   rest_api_id   = aws_api_gateway_rest_api.example.id
# }

# resource "aws_api_gateway_integration" "example" {
#   http_method = aws_api_gateway_method.example.http_method
#   resource_id = aws_api_gateway_resource.example.id
#   rest_api_id = aws_api_gateway_rest_api.example.id
#   type        = "MOCK"
# }

# resource "aws_api_gateway_deployment" "example" {
#   rest_api_id = aws_api_gateway_rest_api.example.id

#   triggers = {
#     # NOTE: The configuration below will satisfy ordering considerations,
#     #       but not pick up all future REST API changes. More advanced patterns
#     #       are possible, such as using the filesha1() function against the
#     #       Terraform configuration file(s) or removing the .id references to
#     #       calculate a hash against whole resources. Be aware that using whole
#     #       resources will show a difference after the initial implementation.
#     #       It will stabilize to only change when resources change afterwards.
#     redeployment = sha1(jsonencode([
#       aws_api_gateway_resource.example.id,
#       aws_api_gateway_method.example.id,
#       aws_api_gateway_integration.example.id,
#     ]))
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_api_gateway_stage" "example" {
#   deployment_id = aws_api_gateway_deployment.example.id
#   rest_api_id   = aws_api_gateway_rest_api.example.id
#   stage_name    = "example"
# }




