# WildRyde infrastructure practice with Terraform
Terraform configuration of WildRydes - A serverless on-demand ride booking application.

# Technologies
AWS Services used:
    - AWS Amplify, DynamoDB, AWS API-Gateway, AWS Lambda, Amazon Cognito, AWS Systems Manager

## To build on terraform
1. run terraform config with your GIT and AWS credentials
2. Log in to the [AWS Amplify console](https://aws.amazon.com/amplify/) and view your App
3. Initialize the build by clicking on `Run Build` OR by pushing changes from your repository (CI/CD pipeline will automatically start the build when there are code changes)

## To clear the infrastructure
### When building the app, several resources will be created by Cloudformation(bucket and Auth roles). This does not incur any additional charges.
1. Run the `terraform destroy` command
2. Clear cloudformation stack created by aws amplify
3. Clear bucket created by Cloudformation (bucket does not automatically empty when Cloudformation stack is deleted).
3. clear repository webhook on github
5. Clear repository deploy keys on github