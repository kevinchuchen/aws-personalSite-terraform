variable "lambda-function-arn"{
    type=string
    description = "ARN of lambda being invoked"
}

variable "lambda-invoke-arn"{
    type=string
    description = "ARN of lambda being invoked"
}

variable "API-GW-name"{
    type=string
    description = "WebApp name used for API Gateway"
}

variable "cognito-UserPool-Arn"{
    type=string
    description = "Cognito User Pool ARN"
}

variable "stage-name"{
    type=string
    description = "stage name for API Gateway"
}