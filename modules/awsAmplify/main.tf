#Hosts an AWS Amplify webapp based on specified github repo

# resource "aws_amplify_app" "amplify" {
#     name = var.amplify-name
#     repository = var.source-repo
#     access_token = var.GITHUB_ACCESS_TOKEN
#     iam_service_role_arn = aws_iam_role.amplify-backend-role.arn
#     enable_branch_auto_build = true
#     description = "Creates a new AWS amplify environment to host your webapp."

    custom_rule {
        source = "</^[^.]+$|\\.(?!(css|gif|ico|jpg|js|png|txt|svg|woff|ttf|map|json)$)([^.]+$)/>"
        status = "200"
        target = "/index.html"
    }
    custom_rule {
        source = "/<*>"
        status = "404"
        target = "/index.html"
    }
    environment_variables = {
        USER_BRANCH = "prod"
        _LIVE_UPDATES = <<-EOT
         [{"name":"Amplify CLI","pkg":"@aws-amplify/cli","type":"npm","version":"latest"}]
         EOT
    }

}

# }

# resource "aws_amplify_branch" "main" {
#   app_id      = aws_amplify_app.amplify.id
#   branch_name = "main"
#   enable_auto_build = true

#   framework = "Vue"

# }

# #Policy document specifying what service can assume the role
# data "aws_iam_policy_document" "amplify_assume_role"{
#     statement {
#         effect = "Allow"
#         actions = ["sts:AssumeRole"]
#         principals {
#           type = "Service"
#           identifiers = [ "amplify.amazonaws.com" ]
#         }
#     }
# }
# #IAM role providing admin access to aws resources
# resource "aws_iam_role" "amplify-backend-role"{
#     name = "amplify-backend-role"
#     assume_role_policy =  data.aws_iam_policy_document.amplify_assume_role.json
#     managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess-Amplify"]
# }