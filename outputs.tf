# output "s3-bucket-address"{
#     description = "Public address of s3"
#     value= module.create-s3-staticSite.s3-staticDomain
# }

output "invokeURL"{
    value = module.create-lambda-function.lambda_invoke_arn

}