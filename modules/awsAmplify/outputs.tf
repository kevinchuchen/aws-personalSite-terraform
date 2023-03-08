# output "s3-staticDomain" {
#     value = aws_s3_bucket_website_configuration.s3-bucket.website_endpoint
#     description = "The public dommain to access the s3 bucket"
# }

output "Amplify-App-ID" {
    value = aws_amplify_app.amplify.id
    description = "Amplify App ID"
}