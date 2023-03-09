variable "amplify-name"{
    type=string
    description= "Amplify environment name"
    default = "wild-rydes-webApp"
}

variable "source-repo"{
    type=string
    description= "webapp source repo"
}

variable "GITHUB_ACCESS_TOKEN"{
    type=string
    description="Github access token"
    sensitive=true
}

variable "AMPLIFY_WEBCLIENT_ID" {
    type=string
    description="Cognito webclient ID"
}

variable "AMPLIFY_USERPOOL_ID" {
    type=string
    description="Cognito user pool ID"
}

variable "AMPLIFY_NATIVECLIENT_ID" {
    type=string
    description="Cognito native client ID"
}

variable "API-GW-InvokeUrl"{
    type=string
    description = "Entrypoint URL of API Gateway invocation"
}