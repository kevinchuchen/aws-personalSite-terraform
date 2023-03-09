output "API-GW-InvokeUrl"{
    value = aws_api_gateway_deployment.api-GW-deployment.invoke_url
    description = "API gateway invoke URL"
}

output "API-GW-ID"{
    value = aws_api_gateway_rest_api.api-gateway.id
    description = "API gateway ID"
}

output "API-GW-Resource-ID"{
    value = aws_api_gateway_resource.api-GW-resource.id
    description = "API gateway resource ID"
}