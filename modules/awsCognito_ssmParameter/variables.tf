variable "cognitoPool-name"{
    type=string
    description= "Cognito pool name name"
    default = "wild-rydes-cognitoPool"
}
variable "cognitoClient-name"{
    type=string
    description= "Cognito client name"
    default = "wild-rydes-client"
}
variable "userPoolId_name"{
    type=string
    description= "User Pool ID"
}
variable "clientId_name"{
    type=string
    description= "Client ID"
}
variable "nativeClientId_name"{
    type=string
    description= "Native Client ID"
}