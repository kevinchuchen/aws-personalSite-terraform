resource "aws_amplify_app" "amplify" {
    name = var.amplify-name
    repository = var.source-repo
    description = "Creates a new AWS amplify environment to host your webapp."
}

