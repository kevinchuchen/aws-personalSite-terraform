#Creates a DynamoDB table to track orders
resource "aws_dynamodb_table" "dynamoDB-main" {
    name = "Rides"
    hash_key = "RideId"
    billing_mode   = "PAY_PER_REQUEST"

    attribute {
        name = "RideId"
        type = "S"
    }
}
