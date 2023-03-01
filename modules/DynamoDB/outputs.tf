output "DynamoDB-ARN" {
    value = aws_dynamodb_table.dynamoDB-main.arn
    description = "ARN of dynamoDB table"
}