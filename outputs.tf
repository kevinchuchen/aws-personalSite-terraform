# output "s3-bucket-address"{
#     description = "Public address of s3"
#     value= module.create-s3-staticSite.s3-staticDomain
# }

output "APIGW-invokeURL"{
    value = module.create-API-Gateway.API-GW-InvokeUrl
}