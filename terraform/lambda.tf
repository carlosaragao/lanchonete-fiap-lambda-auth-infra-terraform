data "archive_file" "fiap_api_artefact" {
    output_path = "files/fiap_api_artefact.zip"
    type = "zip"
    source_file = "${local.lambdas_path}/auth-api/index.js"
}

resource "aws_lambda_function" "fiap_auth_api" {
    function_name = "fiap_auth_api"
    handler = "index.handler"
    role = "arn:aws:iam::226970162258:role/LabRole"
    runtime = "nodejs20.x"

    filename = data.archive_file.fiap_api_artefact.output_path
    source_code_hash = data.archive_file.fiap_api_artefact.output_base64sha256

    timeout = 5
    memory_size = 128

    layers = [aws_lambda_layer_version.auth_api.arn]
}