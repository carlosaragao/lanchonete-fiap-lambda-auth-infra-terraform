data "archive_file" "fiap_create_user_api_artefact" {
    output_path = "files/fiap_create_user_api_artefact.zip"
    type = "zip"
    source_file = "${local.lambdas_path}/create-user-api/index.js"
}

resource "aws_lambda_function" "fiap_create_user_api" {
    function_name = "fiap_create_user_api"
    handler = "index.handler"
    role = "arn:aws:iam::226970162258:role/LabRole"
    runtime = "nodejs20.x"

    filename = data.archive_file.fiap_create_user_api_artefact.output_path
    source_code_hash = data.archive_file.fiap_create_user_api_artefact.output_base64sha256
    environment {
        variables = {
            USER_POOL_ID = aws_cognito_user_pool.lanchonete_fiap_user_pool.id
        }
    }
    timeout = 5
    memory_size = 128

    layers = [aws_lambda_layer_version.auth_api.arn]
}

resource "aws_lambda_permission" "fiap_create_user_api" {
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fiap_create_user_api.arn
  principal = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${var.AWS_REGION}:${var.AWS_ACCOUNT_ID}:*/*"
}

data "archive_file" "fiap_auth_user_api_artefact" {
    output_path = "files/fiap_auth_user_api_artefact.zip"
    type = "zip"
    source_file = "${local.lambdas_path}/auth-api/index.js"
}

resource "aws_lambda_function" "fiap_auth_user_api" {
    function_name = "fiap_auth_user_api"
    handler = "index.handler"
    role = "arn:aws:iam::226970162258:role/LabRole"
    runtime = "nodejs20.x"

    filename = data.archive_file.fiap_auth_user_api_artefact.output_path
    source_code_hash = data.archive_file.fiap_auth_user_api_artefact.output_base64sha256
    environment {
        variables = {
            USER_POOL_ID = aws_cognito_user_pool.lanchonete_fiap_user_pool.id
            AWS_COGNITO_CLIENT_ID = aws_cognito_user_pool_client.fiap-client.id
        }
    }
    timeout = 5
    memory_size = 128

    layers = [aws_lambda_layer_version.auth_api.arn]
}

resource "aws_lambda_permission" "fiap_auth_user_api" {
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fiap_auth_user_api.arn
  principal = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${var.AWS_REGION}:${var.AWS_ACCOUNT_ID}:*/*"
}
