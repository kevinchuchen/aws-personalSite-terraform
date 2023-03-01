#Creates a lambda function for full serverless backend - coupled with the required IAM permissions to access AWS services
data archieve_file "archieve"
resource "aws_lambda_function" "order_ride_lambda" {

}



resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "lambda_function_payload.zip"
  function_name = "lambda_function_name"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.test"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = "nodejs16.x"

  environment {
    variables = {
      foo = "bar"
    }
  }
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
#Creates DynaboDB writeOnly policy
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