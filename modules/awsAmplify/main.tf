#Hosts an AWS Amplify webapp based on specified github repo

resource "aws_amplify_app" "amplify" {
    name = var.amplify-name
    repository = var.source-repo
    access_token = var.GITHUB_ACCESS_TOKEN
    iam_service_role_arn = aws_iam_role.amplify-backend-role.arn
    enable_branch_auto_build = true

    build_spec = <<-EOT
        version: 1
        backend:
            phases:
                build:
                    commands:
                        - '# Execute Amplify CLI with the helper script'
                        - yum install jq -y
                        - npm i amplify-headless-interface
                        - amplifyPush --simple
                        - echo $secrets > authconfig.importauth.json
                        - cat authconfig.importauth.json | jq -c '. += {"version":1}' | amplify import auth --headless
                        - echo "VUE_APP_APIGW_INVOKEURL=$API_GATEWAY_INVOKEURL" >> .env
                        - cat .env
                        - amplifyPush --simple

        frontend:
            phases:
                preBuild:
                    commands:
                        - npm install
                build:
                    commands:
                        - npm run build


            artifacts:
                baseDirectory: dist
                files:
                - '**/*'
            cache:
                paths:
                    - node_modules/**/*

    EOT

    description = "Creates a new AWS amplify environment to host your webapp."

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
        USER_BRANCH = "prod",
        _LIVE_UPDATES = <<-EOT
         [{"name":"Amplify CLI","pkg":"@aws-amplify/cli","type":"npm","version":"latest"}]
         EOT
        AMPLIFY_NATIVECLIENT_ID = var.AMPLIFY_NATIVECLIENT_ID	
        AMPLIFY_USERPOOL_ID = var.AMPLIFY_USERPOOL_ID
        AMPLIFY_WEBCLIENT_ID = var.AMPLIFY_WEBCLIENT_ID
        API_GATEWAY_INVOKEURL = var.API-GW-InvokeUrl
    }

}


resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.amplify.id
  branch_name = "main"
  enable_auto_build = true

  framework = "Vue"

}

#Policy document specifying what service can assume the role
data "aws_iam_policy_document" "amplify_assume_role"{
    statement {
        effect = "Allow"
        actions = ["sts:AssumeRole"]
        principals {
          type = "Service"
          identifiers = [ "amplify.amazonaws.com" ]
        }
    }
}
#IAM role providing admin access to aws resources
resource "aws_iam_role" "amplify-backend-role"{
    name = "amplify-backend-role"
    assume_role_policy =  data.aws_iam_policy_document.amplify_assume_role.json
    managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess-Amplify"]
}