#Creates a lambda function for full serverless backend - coupled with the required IAM permissions to access AWS services
data "archive_file" "lambda" {
  type = "zip"
  source_file = "${path.module}/NodeJS/index.js"#var.lambda-source
  output_path = "${path.module}/NodeJS/lambda.zip"#var.lambda-output
}
resource "aws_lambda_function" "order_ride_lambda" {
  filename = "${path.module}/NodeJS/lambda.zip"
  function_name = "WildRydesLambda"
  role = aws_iam_role.lambda-role.arn
  handler = "index.handler"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  # source_code_hash = filebase64sha256("data.archive_file.lambda.output_path")
  runtime = "nodejs12.x"

}


#Policy document specifying what service can assume the role
data "aws_iam_policy_document" "lambda_assume_role"{
    statement {
        effect = "Allow"
        actions = ["sts:AssumeRole"]
        principals {
          type = "Service"
          identifiers = [ "lambda.amazonaws.com" ]
        }
    }
}
#Creates DynamoDB writeOnly policy
resource "aws_iam_policy" "wildrydes-DDB-writeOnly" {
  name = "WildRydes-DynamoDB-WriteOnly"
  description = "Allows WildRydes lambda function write access to DynamoDB"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["dynamodb:PutItem"]
        Effect   = "Allow"
        Resource = var.lambda-dynamoDB-ARN
      },
    ]
  })
}

#Attach IAM policy to IAM role providing lambda ExecutionRole and DynamoDB read access
resource "aws_iam_role" "lambda-role"{
    name = "wild-rydes-lambda-iam-role"
    assume_role_policy =  data.aws_iam_policy_document.lambda_assume_role.json
    managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",aws_iam_policy.wildrydes-DDB-writeOnly.arn]
}