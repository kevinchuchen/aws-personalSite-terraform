variable "lambda-source"{
    type=string
    description = "Source lambda file"
}
variable "lambda-output"{
    type=string
    description = "Output lambda file"
}

variable "lambda-dynamoDB-ARN"{
    type=string
    description = "The DynamoDB instance that this lambda function interacts with"
}