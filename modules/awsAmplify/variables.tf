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
