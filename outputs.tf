# output "layers" {
#   value = [{
#     auth-api = {
#         arn = aws_lambda_layer_version.auth-api.arn
#         name = aws_lambda_layer_version.auth_api.layer_name
#         version = aws_lambda_layer_version.auth_api.version
#         description = aws_lambda_layer_version.auth_api.description
#         created_at = aws_lambda_layer_version.auth_api.created_at
#     }
#   }]
# }

# output "lambdas" {
#   value = [{
#     arn = aws_lambda_function.auth_api.arn
#     name = aws_lambda_function.auth_api.function_name
#     description = aws_lambda_function.auth_api.description
#     version = aws_lambda_function.auth_api.version
#     last_modified = aws_lambda_function.auth_api.last_modified
#   }]
# }