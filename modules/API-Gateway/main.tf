
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda-function-arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api-gateway.execution_arn}/*/*/*"
}


#API Gateway acts as an entry point for the webapp to trigger lambda function

resource "aws_api_gateway_rest_api" "api-gateway" {
    name = "${var.API-GW-name}-API-gateway"
}

resource "aws_api_gateway_authorizer" "api-GW-authorizer" {
    name = "${var.API-GW-name}-authorizer"
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

resource "aws_api_gateway_stage" "api-GW-stage" {
  deployment_id = aws_api_gateway_deployment.api-GW-deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api-gateway.id
  stage_name    = var.stage-name
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  resource_id = aws_api_gateway_resource.api-GW-resource.id
  http_method = aws_api_gateway_method.api-GW-POST.http_method
  response_models = {"application/json" = "Empty"}
  status_code = 200
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true,
  }
  depends_on = [aws_api_gateway_method.api-GW-POST]

}


resource "aws_api_gateway_integration" "apiGW-Lambda-Integration" {
  rest_api_id   = aws_api_gateway_rest_api.api-gateway.id
  resource_id   = aws_api_gateway_resource.api-GW-resource.id
  http_method   = aws_api_gateway_method.api-GW-POST.http_method
  integration_http_method = "POST"
  type          = "AWS_PROXY"
  uri           = var.lambda-invoke-arn
}

resource "aws_api_gateway_deployment" "api-GW-deployment" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id

  depends_on = [
    aws_api_gateway_method_response.response_200,
    # aws_api_gateway_integration_response.apiGW-integration-response
  ]
  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.api-GW-resource.id,
      aws_api_gateway_method.api-GW-POST.id,
      aws_api_gateway_integration.apiGW-Lambda-Integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

